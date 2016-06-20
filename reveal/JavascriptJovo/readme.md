This is the second in a series of [3D scatter plots](http://bl.ocks.org/phil-pedruco/9852362) rendered using webGL.  The first example used static data stored on the server whereas this example allows users to upload csv files. The files need to be in the following format:

<table>
<thead>
<tr>
<th>Var 1a</th>
<th>Var 2a</th>
<th>Var 3a</th>
<th>Var 1b</th>
<th>Var 2b</th>
<th>Var 3b</th>
<th>Var 1c</th>
<th>Var 2c</th>
<th>Var 3c</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>x1</strong></td>
<td><strong>y1</strong></td>
<td><strong>z1</strong></td>
<td><strong>x2</strong></td>
<td><strong>y2</strong></td>
<td><strong>z2</strong></td>
<td><strong>x3</strong></td>
<td><strong>y3</strong></td>
<td><strong>z3</strong></td>
</tr>
<tr>
<td>235</td>
<td>597</td>
<td>487</td>
<td>232</td>
<td>593</td>
<td>156</td>
<td>325</td>
<td>945</td>
<td>332</td>
</tr>
<tr>
<td>458</td>
<td>702</td>
<td>724</td>
<td>735</td>
<td>152</td>
<td>717</td>
<td>273</td>
<td>350</td>
<td>598</td>
</tr>
</tbody>
</table>
And if you don't have any data formatted just that way you can use [this csv file](https://gist.githubusercontent.com/phil-pedruco/9852362/raw/6764ed563711fa42dae37bf61f2c4e31a75b13cc/defaultData.csv). Note that you can only upload one csv at a time.  If you want to view another csv just refresh the page.

You can change view by rotating cube using the mouse, move it left and right to rotate the cube around the y-axis and up and down to rotate it about the x adn z axis's.  At present there's no relationship between the colours of the particles.

The visualisation uses the fantastic [threejs library](http://threejs.org/) for the 3D and hooks into webGL.  The example presented here is heavily based on the threejs scatter plot example.  I've also used [d3.js](http://d3js.org) for some of convenience functions to import the data, scale the data and set up the ranges for the axis's.