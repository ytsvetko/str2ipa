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

def CONSONANT = bċdfġgħhjklmnpqrstvwxżz
def VOWEL = aeiou
def NASAL = mn
def STOP = pbtdkgq
def AFFRICATE = zġċ
def FRICATIVE = fvszxħ
def TRILL = r
def APPROXIMANT = ljw

# Diphthongs
ghaj ||| ʌi
ghi ||| ei
ghu ||| oʊ

għ$ ||| ħ
h$ ||| ħ
għh ||| ħħ

# Final consonants are devoiced
b$ ||| p
d$ ||| t
ġ$ ||| tʃ
g$ ||| k
v$ ||| f
ż$ ||| s

# i before għ, h, ħ or q = [iː]
igħ ||| iː
ih ||| iː
iħ ||| iː
iq ||| iːʔ

# għ is silent but pharyngealizes and lengthens vowels
{VOWEL}għ ||| ː
għ ||| Ø


# m followed by a consonant at the beginning of a word is pronounced im
^m{CONSONANT} ||| im

żj ||| ʒi

# Vowels
a ||| ɐ
eh ||| ɛː
e ||| ɛ
ie ||| iː iɛ
i ||| i
o ||| ɔ
u ||| ʊ uː

# Consonants
b ||| b
ċ ||| tʃ
d ||| d
f ||| f
ġ ||| dʒ
g ||| g
ħ ||| ħ
h ||| Ø
j ||| j
k ||| k
l ||| l
m ||| m
n ||| n
p ||| p
q ||| ʔ
r ||| r
s ||| s
t ||| t
v ||| v
w ||| w
x ||| ʃ
ż ||| z
z ||| ts dz

# mapping is based on http://www.omniglot.com/writing/maltese.htm  https://en.wikipedia.org/wiki/Maltese_language https://en.wikipedia.org/wiki/Help:IPA_for_Maltese
