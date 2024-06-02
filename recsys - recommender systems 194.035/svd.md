- https://www.youtube.com/playlist?app=desktop&list=PLWhu9osGd2dB9uMG5gKBARmk73oHUUQZS
- https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab

# basics

*linear independence of vectors*

- linearly dependent vectors: $\exists a,b: \vec u = a \vec v + b \vec w$ → meaning that vectors are the same, just scaled differently
- linearly independent vectors: $\not\exists a,b: \vec u = a \vec v + b \vec w$
- the basis of a vector space (ie. $\hat x, \hat y, \hat z$) is a set of linearly independent vectors that span the full space

*dot product*

- https://betterexplained.com/articles/vector-calculus-understanding-the-dot-product/
- $\small \vec v \cdot \vec w = \begin{bmatrix} a \\ c \end{bmatrix} \cdot \begin{bmatrix} b \\ d \end{bmatrix} = ab + cd$
- equivalent to the length of $\vec w$ if projected on $\vec v$, times $\vec v$
- one vector could be interpreted as a transformation matrix that projects all vectors in the vectorspace to a 1 dimensional scalar by defining where the unit vectors should land: $\begin{bmatrix} a & c \end{bmatrix}\begin{bmatrix} b \\ d \end{bmatrix}$
- associative
- negative if projection is on opposing directions

*cross product*

- $\small \vec v \times \vec w = \begin{bmatrix} v_1 \\ v_2 \\ v_3 \end{bmatrix} \times \begin{bmatrix} w_1 \\ w_2 \\ w_3 \end{bmatrix} = \text{det}\left(   \begin{bmatrix} \hat x & v_1 & w_1 \\ \hat y & v_2 & w_2 \\ \hat z & v_3 & w_3 \end{bmatrix}    \right) \cdot \vec p$
- results in a perpendicular vector scaled with the area of a spanned paralellogram between the two input vectors
- not associative

*linear transformation matrix*

- https://en.m.wikipedia.org/wiki/Transformation_matrix
- https://en.m.wikipedia.org/wiki/System_of_linear_equations
- https://mathinsight.org/linear_transformation_definition_euclidean
- $A \cdot \vec x = \vec v$
- $L(\vec x) = \vec v$
- can also be expressed as a set of linear equations
	- this set can be solved by finding $A^{-1}$ and then applying it as $\vec x = A^{-1} \cdot \vec v$
	- but only if $\text{det}(A) \not = 0$
- **linearity**:
	- $L(\vec v + \vec w) = L( \vec v) + L( \vec w)$
	- $L(c \vec v) = c L(\vec v)$
	- gridlines, basis vectors remain evenly spaced
	- origin maps to origin
- **matrix composition**:
	- you can also apply multiple transformations
	- $M_1 M_2 \vec v = \vec x$
	- matrix composition is like applying multiple functions, which is why the multiplication isn't associative $f(g(x)) \not = g(f(x))$ and we read $M_1 M_2$ from left to right.

*kernel*

- https://en.m.wikipedia.org/wiki/Kernel_(linear_algebra)
- also called: null space, zero vector
- $\text{ker}(L) = L^{-1}(0)$
- all possible $\vec v$ that would be mapped to $\vec 0$

*span / column space*

- https://en.m.wikipedia.org/wiki/Row_and_column_spaces
- **vectors**:
	- $a \vec v + b \vec w$ is the set of all possible linear combinations of the two vectors $\vec v, \vec w$ assuming $a,b$ are scalars
	- equivalent for 1 or more vectors
- **matrices**:
	- $\text{span}(A) = \text{rowsp}(A) = \text{colsp}(A)$ 
	- also called: matrix range, image, span, column space
	- the set of all possible outputs of $A \vec v$
		- the span of the columns of the matrix
		- the set of all possible linear combinations of its column vectors
	- why the column vectors?
		- $A$ is a column wise mapping of the basis vectors (ie. $\hat x, \hat y$)
		- $\small \hat x = \begin{bmatrix} 1 \\ 0 \end{bmatrix}$
		- $\small \hat y = \begin{bmatrix} 0 \\ 1 \end{bmatrix}$
		- $\small \begin{bmatrix} a & b \\ c & d \end{bmatrix} \cdot \begin{bmatrix} x \\ y \end{bmatrix} = x \cdot \begin{bmatrix} a \\ c \end{bmatrix} + y \cdot \begin{bmatrix} b \\ d \end{bmatrix} = \begin{bmatrix} ax + by \\ cx + dy \end{bmatrix}$
		- if the matrix is non-square, that means we are mapping between different dimensions

*rank*

- https://en.m.wikipedia.org/wiki/Row_and_column_spaces
- https://en.m.wikipedia.org/wiki/Row_echelon_form
- $\text{rank}(A) = \text{dim}(\text{rowsp}(A)) = \text{dim}(\text{colsp}(A))$ 
- the number of dimensions covered by the span of the vectors of after applying a matrix transformation
- the number of linearly independent columns in column vectors of a matrix

*determinant* 

- $\text{det}(A)$ 
- $\text{rank}(A) = 1 \implies \text{det}(A) = 0$
- by what factor the area spanned by the basic vectors gets expanded / shrunken by the mapping
- the determinant is 0 if the resulting basis vectors from the matrix transformation are linearly dependent (area gets shrunken to 0)

*eigenvector, eigenvalue*

- https://en.m.wikipedia.org/wiki/Eigenvalues_and_eigenvectors
- $T(\vec{v})=(\lambda I)\vec{v}$
	- $T$ transformation = doesn't have to be linear, so not $L$
	- $\vec v$ eigenvector = vectors that don't change their span after a transformation
	- $\lambda$ eigenvalue = value by which the eigenvector is scaled in a transformation
	- $I$ identity matrix = $\begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix}$
- in a diagonal matrix (like the identity matrix) all the column vectors are eigenvectors with their only non-zero value being their eigenvalue
- an "eigenbasis" is a new set of basis vectors / vector system, from which a transformation looks llike a diagonal matrix

# single value decomposition svd

*interesting matrices*

- https://en.m.wikipedia.org/wiki/List_of_named_matrices
- $I$ **identity matrix**
	- https://en.wikipedia.org/wiki/Identity_matrix
	- no transformation
	- example: $\tiny \begin{bmatrix} 1 & 0  \\ 0 & 1 \end{bmatrix}$
- $\lambda I$ **scalar matrix**
	- https://en.wikipedia.org/wiki/Diagonal_matrix#Scalar_matrix
	- identity matrix multiplied by $k$
	- example: $\tiny \begin{bmatrix} k & 0  \\ 0 & k \end{bmatrix}$
- $\text{Ret}$ **reflection matrix**
	- https://en.wikipedia.org/wiki/Rotations_and_reflections_in_two_dimensions
	- flips over one axis
	- example: $\tiny \begin{bmatrix} 0 & 1  \\ -1 & 0 \end{bmatrix}$
- $\Lambda / D$ **diagonal matrix**
	- https://en.wikipedia.org/wiki/Diagonal_matrix
	- any matrix where only the diagonal has non zero vallues
	- scales in different dimension
- **shear matrix**
	- https://en.wikipedia.org/wiki/Shear_mapping
	- shifts one axis, while the other stays constant
	- example: $\tiny \begin{bmatrix} 1 & 1  \\ 0 & 1 \end{bmatrix}$
- $P$ **projection matrix**
	- https://en.wikipedia.org/wiki/Projection_(linear_algebra)
	- projects to a subspace
	- example: $\tiny \begin{bmatrix} 1 & 0  \\ 0 & 0 \end{bmatrix}$
- $Q / \text{Rot}$ **orthogonal**
	- https://en.wikipedia.org/wiki/Orthogonal_matrix
	- rotation
	- are column vectors are unit vectors
	- if you transpose it, you rotate in the inverse direction
	- $Q^T = Q^{-1}$
	- example: $\tiny \begin{bmatrix} \sqrt{2}/2 & \sqrt{2}/2 \\ \text{-}\sqrt{2}/2  & \sqrt{2}/2 \end{bmatrix}$
- $S$ **symmetric matrix**
	- https://en.wikipedia.org/wiki/Symmetric_matrix
	- https://en.wikipedia.org/wiki/Diagonalizable_matrix
	- $S = S^T$
	- eigenvectors are always perpendicular (90°) to eachother
	- if we take the eigenvectors, normalize them, put them into the columns of a matrix, transpose them, then they align with the standard basis vectors
	- multiplication is associative
	- example: $\tiny \begin{bmatrix} 1 & -2  \\ -2 & 3 \end{bmatrix}$

*eigen decomposition EVD*

- https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix#Example
- works on any square matrix with linearly independent eigenvectors (the number of the eigenvectors must be equal to their dimension)
- concrete example with symmetric matrices:
	- $S = Q \Lambda Q^{T}$
	- $S$ = symmetric matrix we want to decompose (find matrices that were composed to derive this one)
	- $Q$ = orthogonal matrix, with the eigenvectors of $S$ as their column vectors
	- $\Lambda$ = diagonal matrix, with normalized eigenvalues of $S$ as their diagonal

*single value decomposition SVD*

- https://en.wikipedia.org/wiki/Singular_value_decomposition#Example
- https://www.youtube.com/watch?v=CpD9XlTu3ys
- generalization of the eigen decomposition
- background:
	- i) we can make any matrix symmetrical by multiplying it with its transposed matrix
		- not associative: $A^T \cdot A \not = A \cdot A^T$
		- we get 2 different symmetrical matrices, based on the order of the multiplication:
			- "**left singular vectors** of $A$"
			- "**right singular vectors** of $A$"
		- they share 2 eigenvalues, the square root of which we call "**singular values** $\sigma$"
	- ii) we can map vectors to arbitrary dimensions $\mathbb R^n \mapsto \mathbb R^m$
		- for example: $\tiny \begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \end{bmatrix} \cdot \begin{bmatrix} x \\ y \\ z\end{bmatrix} = \begin{bmatrix} x \\ y \end{bmatrix}$ maps $\mathbb R^2 \mapsto \mathbb R^3$
		- for example: $\tiny \begin{bmatrix} 1 & 0 \\ 0 & 1 \\ 0 & 0 \end{bmatrix} \cdot \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} x \\ y \\ z \end{bmatrix}$ maps $\mathbb R^2 \mapsto \mathbb R^3$
- svd:
	- $A = U \cdot \Sigma \cdot V^T$
	- $U$ = **orthogonal matrix**
		- = normalized eigenvectors of the "left singular vectors of $A$"
		- rotates vectors to the standard basis vectors
	- $\Sigma$ = **rectangular diagonal matrix**
		- = same dimensions, singular values diagonally
		- flattens out and removes a dimension
		- stretches x,y axis based on the singular value
	- $V$ = **orthogonal matrix**
		- = normalized eigenvectors of the "right singular vectors of $A$"
		- rotates vectors to the standard basis vectors
		- single vector with largest value lands on the x-axis, the second largest value on the y-axis, etc.
