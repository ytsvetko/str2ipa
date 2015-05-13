#!/usr/bin/env python3

"""
./str2ipa.py --mapping_file data/mapping/letter-to-phone-mapping.<lang> \ 
             --in_vocab data/vocab/vocab.<lang> \
             --out_pron_dict data/pron-dict/pron-dict.<lang> \


./str2ipa.py --mapping_file data/mapping/letter-to-phone-mapping.ro \
             --in_vocab data/vocab/vocab.ro \
             --out_pron_dict data/pron-dict/pron-dict.ro

"""
import argparse
import itertools
import collections
import unicodedata

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--mapping_file', default='./letter-to-phone-mapping.fr')
  parser.add_argument('--in_vocab')
  parser.add_argument('--out_pron_dict')
  parser.add_argument('--debug_match', action='store_true')
  parser.add_argument('--ignore_errors', action='store_true')
  args = parser.parse_args()

EMPTY_CHAR = "Ø"

class IpaRule(object):
  def __init__(self, rule_line_num: int, match_str : str, consume_mask : list, replace_rules : list):
    self.rule_line_num = rule_line_num
    self.match_str = match_str
    self.consume_mask = consume_mask
    self.replace_rules = replace_rules

  def TryMatch(self, s: str, mask: list):
    """Tries to match the rule given the mask.
    Returns True iff matched.
    Each element in |mask| is either boolean or list.
    If it is False - this position was not consumed yet.
    If it is True - this position was consumend, but does not provide output of its own.
    If it is a list - the list contains all possible output strings starting at this position.
    """
    matched = False
    pos = 0
    while True:
      pos = s.find(self.match_str, pos)
      if pos == -1:
        break
      if not self.CheckMaskAtPos(mask, pos):
        pos += 1
      else:
        matched = True
        appended_output = False
        for i, consume in enumerate(self.consume_mask):
          if consume:
            if not appended_output:
              mask[pos+i] = (self, self.replace_rules)
              appended_output = True
            else:
              mask[pos+i] = True
    return matched

  def CheckMaskAtPos(self, mask : list, pos : int):
    for i, consume in enumerate(self.consume_mask):
      # mask[pos+i] can be a bool or a list.
      if consume and mask[pos+i] is not False:
        return False
    return True
  
  def __repr__(self):
    bitmask = []
    for b in self.consume_mask:
      bitmask.append("T" if b else "F")
    return "{self.match_str}/{self.rule_line_num}/{bitmask}".format(self=self, bitmask="".join(bitmask))

class IpaMapper(object):
  def __init__(self, mapping_filename):
    self.defined_vars = {}
    self.rules = []
    self.LoadMapping(mapping_filename)
  
  def LoadMapping(self, mapping_filename):
    for line_num, line in enumerate(open(mapping_filename)):
      line_num += 1
      try:
        # Strip the comments and whitespace
        pos = line.find("#")
        if pos != -1:
          line = line[:pos]
        line = line.strip()
        if len(line) == 0:
          continue

        # Parse matcher set definitions
        if line.startswith("def "):
          self.ParseDef(line[4:])
          continue

        match_rule, replace_rules = line.split(" ||| ")
        self.AppendRules(line_num, match_rule, replace_rules.split(" "))
      except:
        print("Error in rules file line:", line_num)
        raise

  def AppendRules(self, line_num, match_rule, replace_rules):
    replace_rules = [x.replace(EMPTY_CHAR, "") for x in replace_rules]
    rule_list = []
    consume_mask = []
    while len(match_rule) > 0:
      if match_rule[0] == "{":
        pos = match_rule.find("}")
        assert pos>0, (match_rule, pos)
        var_name = match_rule[1:pos]
        rule_list.append(self.defined_vars[var_name])
        consume_mask.append(False)
        match_rule = match_rule[pos+1:]
      else:
        rule_list.append([match_rule[0]])
        consume_mask.append(True)
        match_rule = match_rule[1:]
    for p_tuple in itertools.product(*rule_list):
      rule_str = "".join(p_tuple)
      rule = IpaRule(line_num, rule_str, consume_mask, replace_rules)
      self.CheckRules(rule)
      self.rules.append(rule)

  def CheckRules(self, rule_to_check):
    s = rule_to_check.match_str
    for prev_rule in self.rules:
      mask = [False] * len(s)      
      if prev_rule.TryMatch(s, mask):
        print("Error: rule {} is consumed by earlier rule {}".format(rule_to_check, prev_rule))

  def ParseDef(self, line):
    name, set_str = line.split("=")
    name = name.strip()
    set_str = set_str.strip()
    self.defined_vars[name] = list(set_str)
    print("Defined rule name:", name, "values:", set_str)

  def ConvertWord(self, s, debug_match=False, ignore_errors=False):
    """Given a word (single words only) returns a list of all pronunciations (no space between phones)."""
    assert("$" not in s)
    assert("^" not in s)
    s = "^" + s + "$"
    mask = [False]*len(s)
    for rule in self.rules:
      # TryMatch updates the mask.
      while rule.TryMatch(s, mask):
        pass

    # Mark start and end chars as consumed.
    mask[0] = True
    mask[-1] = True
    if False in mask and not ignore_errors:
      print("No rules matched for: {}, mask: {}".format(s, mask))
    
    out_str_lists = []
    for elem in mask:
      if type(elem) == tuple:
        out_str_lists.append(elem[1])
    
    out_strs = []
    for p_tuple in itertools.product(*out_str_lists):
      if len(p_tuple) > 0:
        out_strs.append("".join(p_tuple))
  
    if debug_match:
      print("Matching word:", s)
      print(mask)
      print("Result:", out_strs)

    return out_strs


def IpaSplit(word, ignore_errors=False):
  result = []
  for i, c in enumerate(word):
    category = unicodedata.category(c)
    if category == "Mn":
      assert len(result) > 0, "Unexpected accent before letter for char: {} in word: {}, len(word): {}".format(c, word, len(word))
      result[-1] = result[-1] + c
    else:
      if category not in {"Ll", "Lu", "Lm"}:
        assert ignore_errors, "Unexpected unicode category for char: {} in word: {}".format(c, word)
      result.append(c)
  return result

def main():
  ipa_mapper = IpaMapper(args.mapping_file)
  phone_dict = {}
  for line in open(args.in_vocab):
    # Only take the first token from each line.
    word = line.split()[0]
    if word not in phone_dict:
      out_pron_list = ipa_mapper.ConvertWord(word, debug_match=args.debug_match, ignore_errors=args.ignore_errors)
      if out_pron_list:
        phone_dict[word] = set(out_pron_list)

  with open(args.out_pron_dict, "w") as out_file:
    for word in sorted(phone_dict):
      for pron in sorted(phone_dict[word]):
        out_file.write("{} ||| {}\n".format(word, " ".join(IpaSplit(pron, ignore_errors=False))))

if __name__ == '__main__':
  main()
