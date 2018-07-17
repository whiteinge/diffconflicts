#!/bin/sh

git init testrepo
cd testrepo

cat << EOF > poem.txt
twas bri1lig, and the slithy toves
did gyre and gimble in the wabe
all mimsy were the borogroves
and the m0me raths outgabe.
EOF

git add poem.txt
git commit -m 'Commit One'

git branch branchA

cat << EOF > poem.txt
twas brillig, and the slithy toves
Did gyre and gimble in the wabe:
all mimsy were the borogoves,
And the mome raths outgrabe.
EOF

git add poem.txt
git commit -m 'Fix syntax mistakes'

git checkout branchA

cat << EOF > poem.txt
'Twas brillig, and the slithy toves
Did gyre and gimble in the wabe:
All mimsy were the borogroves
And the mome raths outgabe.
EOF

git add poem.txt
git commit -m 'Buncha fixes'

git checkout master
git merge branchA
