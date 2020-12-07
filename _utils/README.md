# A mergetool rant

diffconflicts is not special or noteworthy. That is true for the original `sed`
shell script and the Vim/vimscript plugin. The core idea from this plugin is
extremely simple and can be expressed as a sed one-liner. What is special is
that most people and most mergetools don't recognize the following points.

The goal of this rant is to get all mergetools to recognize these ideas and to
adopt this technique. Editor holy wars are not important; making merge conflict
resolution easier is important.

- Git provides a great deal of value by automatically resolving many conflicts.
  The fruit of this effort is only expressed in the file containing conflict
  markers.
- It is difficult for a human to look at a file containing conflict markers. It
  is impossible to reliably spot subtle differences.
- A human should never manually edit a file containing conflict markers. It is
  too easy to make mistakes. Eyeballing two hunks of changes, positioned
  vertically, is a fool's errand without tooling support.
- Often a conflict resolution requires a mix of both left and right and not
  just all of left or all of right. Because it is difficult to carefully read
  and mentally compare each change many people simply choose the left or the
  right change which can result in the loss of a wanted change.
- A diff between `LOCAL` and `REMOTE` is a bad approach. It bypasses all the
  work Git already did to automatically resolve conflicts and and forces the
  user to resolve those yet again but manually. It presents unecessary visual
  noise to the user by showing things that were already resolved to the user.

## Mergetool Benchmarks

There's a few noteworthy things in the conflicts that the `make-conflicts.sh`
script produces. These points can be used to benchmark the effectiveness of
a given mergetool. More should be added.

1.  The `bri1lig` -> `brillig` conflict was automatically resolved. It should
    not be shown to the user.
2.  The `m0me` -> `mome` conflict was automatically resolved. It should not be
    shown to the user.
3.  The `did` -> `Did` conflict was automatically resolved. It should not be
    shown to the user.
4.  All conflicts in the second stanza were automatically resolved. They should
    not be shown to the user.
5.  The conflict on the first line _is_ an "ours vs. theirs" situation. We only
    want theirs.
6.  The conflict on the third line _is not_ an "ours vs. theirs" situation. We
    want changes from both:

    - Want the capitalization change from theirs.
    - Want the extra 'r' removal from ours.
    - Want the hanging punctuation change from ours.

7.  The conflict on the fourth line should be easily noticeable. We want the
    'r'.
