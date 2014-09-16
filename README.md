This is an algorithm to optimize matches. It is a generalized version of the Hungarian algorithm from match theory, meaning that it optimizes matches even for matrices that are non-square.

What is a match? Suppose there are a group of people who are going to put on a play. These people have different preferences as to which roles they would like to have. Some would really like to play Romeo, others Juliet. A choice is going to have to be made about who plays whom. When we make such a choice, we are making a "match" between actors and roles--a pairing off, or mapping, between actors and roles. Put a little more precisely, a match between A's and B's is any subset of the cross product of A and B.

Not all matches are created equally. Suppose there are only two actors (Jim and Martha) and two roles (Romeo and Juliet). Jim wants to play Romeo and does not want to play Juliet. Martha wants to play Juliet and not Romeo. A match, then, which assigned Jim to Juliet and Martha to Romeo would be a worse, or less optimal match, than one which assigned Jim to Romeo and Martha to Juliet. An optimal match is a match which is locally best with respect to some property--meaning that no other match on the same domain is better than it with respect to that property. In our example here, the match of Jim to Romeo, Martha to Juliet was optimal with respect to the actors' preferences.

An algorithm exists for calculating optimized matches. It is called the "Hungarian Algorithm". But one problem with the Hungarian algorithm is that it only works when the sets of individuals to be matched (e.g. actors, roles) are equal in size. When they are not--when, say, there are more roles than there are actors--the Hungarian Algorithm will leave out the extra individuals. They won't be matched. This is often not what we want it to do. Very likely, we'd want every role in our play assigned to an actor. Else it might turn out that crucial characters are missing! "O Romeo, Romeo! wherefore art thou Romeo?"

This, then, is an attempt to generalize the Hungarian algorithm. It takes the same general strategy, but it is broadened in ways which allow it to handle uneven matches. It makes two important assumptions: (1) an optimal match is one in which every individual is matched with at least one other individual; and (2) an optimal match is one in which the mapping is as even as possible, i.e. members of the same set are all matched with the same number of individuals (+/-1). So it won't ever be the case that Jim is assigned to 10 roles, and Martha to 3.

It seems to me that we encounter matching problems like the one described all the time. We encounter them when:
(1) assigning roles to members of a team
(2) making factories/plants more efficient by assigning jobs to workers on the basis of their varying rates of pay, or speed of work
(3) matching students with classes for enrollment
(4) matching residents with residency programs
(5) pairing foster parents with children
(6) determining the best way to distribute blood at a blood bank
(7) matching organ donors to which patients
(9) matching actors to roles, or musicians to parts, in a school play

And so on. Such problems are as widespread as they are difficult to solve. And they seldom involve matching equal sets.