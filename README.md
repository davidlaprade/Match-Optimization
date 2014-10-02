# Match Optimization

This is an algorithm to optimize matches. It is a generalized version of the [Hungarian Algorithm](http://en.wikipedia.org/wiki/Hungarian_algorithm), meaning that it can provide optimal matches even when matching sets of different sizes.

To try it for yourself! Fork this project and run ```ruby demo.rb``` from the terminal.

## Uses
We encounter matching problems all the time. We encounter them when:
- assigning roles to members of a team
- matching organ donors to patients
- assigning jobs to workers based on rates of pay, or speed of work
- matching students with classes for enrollment
- determining the best way to distribute blood at a blood bank
- matching actors to roles in a school play
- matching musicians to parts in an orchestra
- pairing players with positions in a Little League game
- matching residents with residency programs at hospitals

And so on. Such problems are as widespread as they are difficult to solve. And they seldom involve matching equal sets. I hope this algorithm will be a solution to such problems.

### Matches
What is a match? Suppose there is a group of people who are going to put on a play. These people have different preferences as to which roles they would like to have. Some would really like to play Romeo, others Juliet. A choice is going to have to be made about who plays whom. When we make such a choice, we are making a "match" between actors and roles--a pairing off, or mapping, between actors and roles. Put a little more precisely, a match between A's and B's is any subset of the cross product of A and B.

### Optimization
Not all matches are created equally. Suppose there are only two actors (Jim and Martha) and two roles (Romeo and Juliet). Jim wants to play Romeo and does not want to play Juliet. Martha wants to play Juliet and not Romeo. A match, then, which assigned Jim to Juliet and Martha to Romeo would be a worse, or less optimal match, than one which assigned Jim to Romeo and Martha to Juliet. An optimal match is a match which is locally best with respect to some property--meaning that no other match on the same domain is better than it with respect to that property. In our example here, the match of Jim to Romeo, Martha to Juliet was optimal with respect to the actors' preferences.

### Hungarian Algorithm
An algorithm exists for calculating optimized matches. It is called the "Hungarian Algorithm". But one problem with the Hungarian algorithm is that it only works when the sets of individuals to be matched (e.g. actors, roles) are equal in size. When they are not--when, say, there are more roles than there are actors--the Hungarian Algorithm will leave out the extra individuals. They won't be matched. This is often not what we want it to do. Very likely, we'd want every role in our play assigned to an actor. Else it might turn out that crucial characters are missing! "O Romeo, Romeo! wherefore art thou Romeo?"

This, then, is an attempt to generalize the Hungarian algorithm to uneven matches. It makes two important assumptions: (1) that an optimal match is one in which every individual is matched with at least one other individual; and (2) that an optimal match is one in which the mapping is as even as possible, i.e. members of the same set are all matched with the same number of individuals (+/-1). So it won't ever be the case that Jim is assigned to 10 roles, and Martha to 3.