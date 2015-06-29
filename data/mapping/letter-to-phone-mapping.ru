# Syntax:
# Comments start with a pound (#) character.
#
# The rules have top-down precedence !!!not recursive!!!
# Once a substring is matched and consumed other matchers won't consume it.
# However, this substring can still be matched using .V. and .C. matchers.
#
# Simple case:
#   <in_str> ||| <out_str1> <out_str2> ...
#   The <in_str> is consumed.
#   <out_strX> can be "Ø" - deletion.
#
# Special matchers - not consuming the anchor characters:
# Suffixes:
#   <in_str>$ ||| <out_str1> ...
#   <in_str> will only be matched if it at the end of the word.
#
# Prefixes:
#   ^<in_str> ||| <out_str1> ...
#   <in_str> will only be matched if it at the start of the word.
#
# Definition of a set:
# def <NAME> = {char1, char2, ...}
#
# Matching:
#   <in_str>{VAR} ||| <out_str1> ...
#   {VAR}<in_str> ||| <out_str1> ...
#   <in_str> will only be matched in a presence of a character from set VAR. Only the <in_str> is consumed.

def CONSONANT = бвгджзйклмнпртфхцчшщъь
def VOWEL = аеёиоэюяуюы
def NASAL = мн
def STOP = бдгптк
def AFFRICATE = цч		
def FRICATIVE = фсшщцчхж
def TRILL = р
def VOICED = бдгвзж 
def VOICELESS = пткцч
def APPROXIMANT = лж
def PALATAL = ь
def PALATALIZED = мнбдгпткфсвзрл
def NOTPALATALIZED = жшщц
def STRESS = +
def O = ое

- ||| Ø

# Vowels
{NOTPALATALIZED}е ||| ɛ
че ||| tʃe
ще ||| ʃe
ье ||| je
ъе ||| je
{CONSONANT}е ||| ʲe
е ||| je

{NOTPALATALIZED}ё ||| o
чё ||| tʃo
щё ||| ʃo
{CONSONANT}ё ||| ʲo
ьё ||| jo
ъё ||| jo
ё ||| jo

{NOTPALATALIZED}ю ||| u
{CONSONANT}ю ||| ʲu
ью ||| ju
ъю ||| ju
ю ||| ju

{CONSONANT}я ||| ʲa
я ||| ja

+о ||| o
^{CONSONANT}о{CONSONANT}$ ||| o
о ||| ɐ

а ||| a
и ||| i
у ||| u
ы ||| ɨ
э ||| ɛ

# Consonants
сщ ||| ʃʲ
сч ||| ʃʲ
^чт ||| ʃt
жч ||| ʃʲ
вств ||| stv
{O}г{O}$ ||| v
{VOWEL}гк ||| xk
{VOWEL}гч ||| xtʃʲ
нн ||| n

б ||| b
в ||| v
г ||| g
д ||| d
ж ||| ʒ
з ||| z
й ||| j
к ||| k
л ||| l
м ||| m
н ||| n
п ||| p
р ||| r
с ||| s
т ||| t
ф ||| f
х ||| x
ц ||| ts
ч ||| tʃʲ
ш ||| ʃ
щ ||| ʃʲ
ъ ||| Ø
{PALATALIZED}ь ||| ʲ
ь ||| Ø
+ ||| Ø

# mapping is based on http:/https://en.wikipedia.org/wiki/Russian_phonology https://en.wikipedia.org/wiki/Help:IPA_for_Russian http://www.omniglot.com/writing/russian.htm 
