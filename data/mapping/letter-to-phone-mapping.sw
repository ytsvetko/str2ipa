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

dh ||| ð
gh ||| ɣ
th ||| θ
kh ||| x
sh ||| ʃ
ch ||| tʃ tʃʰ

# Vowels
a ||| ɑ
e ||| ɛ
i ||| i
o ||| ɔ
u ||| u

# Nasals
ng ||| ŋ
ny ||| ɲ
m ||| m
n ||| n

# Consonants
b ||| b
d ||| d
g ||| g
j ||| ɟ
p ||| p pʰ
t ||| t tʰ
k ||| k kʰ
h ||| h
l ||| l
r ||| r
f ||| f
s ||| s
v ||| v
y ||| j
w ||| w
z ||| z

c ||| k
q ||| k

x ||| ks

# mapping is based on http://en.wikipedia.org/wiki/Swahili_language
