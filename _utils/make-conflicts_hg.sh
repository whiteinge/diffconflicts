#!/bin/sh

hg init testrepo_hg
cd testrepo_hg

cat << EOF > poem.txt
twas bri1lig, and the slithy toves
did gyre and gimble in the wabe
all mimsy were the borogroves
and the m0me raths outgabe.

"Beware the Jabberwock, my son!
The jaws that bite, the claws that catch!
Beware the Jub jub bird, and shun
The frumious bandersnatch!"
EOF

hg add poem.txt
hg bookmark master
hg commit -m 'Commit One'

cat << EOF > poem.txt
'Twas brillig, and the slithy toves
Did gyre and gimble in the wabe:
All mimsy were the borogroves
And the mome raths outgabe.

"Beware the Jabberwock, my son!
The jaws that bite, the claws that catch!
Beware the Jub jub bird, and shun
The frumious bandersnatch!"
EOF

hg bookmark branchA
hg commit -m 'Buncha fixes'


hg update -Cr master
cat << EOF > poem.txt
twas brillig, and the slithy toves
Did gyre and gimble in the wabe:
all mimsy were the borogoves,
And the mome raths outgrabe.

"Beware the Jabberwock, my son!
The jaws that bite, the claws that catch!
Beware the Jubjub bird, and shun
The frumious Bandersnatch!"
EOF
hg commit -m 'Fix syntax mistakes'

hg --config ui.merge=internal:merge merge branchA
