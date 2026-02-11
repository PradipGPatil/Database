Exercise
Leverage TRUNCATE to re-use temp tables in your solution to "CREATE and INSERT" exercise.
Your output should look something like this:


Hints:
1.)

Instead of joining two tables in your final SELECT (#AvgSalesMinusTop10 and #AvgPurchasesMinusTop10), you will most likely need to join
 a single consolidated query to itself.

The join will work much like before, but you will need to add a new wrinkle that filters each copy of the table based on whether it contains purchase or
 sales data.

For whatever copy of the table you put after the FROM, include the filtering criteria in the WHERE clause.

For the other copy of the table, apply the filtering criteria directly in the join.

These different "cuts" of the same table will accomplish the same thing as two distinct tables did previously.



2.)

In the SELECT clause of your final query, you will probably need to apply aliases to a couple of field names

to distinguish total sales from total purchases. Make sure you apply the appropriate alias to the field

from the appropriate copy of the table.