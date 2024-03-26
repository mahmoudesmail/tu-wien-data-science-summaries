# intro

*recommender systems*

- tool that can guide you through a decision process by ranking your options
- input: items
- output: recommendation list
- types:
	- **popularity based**:
		- what most other users like
		- input: community data (not personal)
	- **demographic based**:
		- what most other users - similar to you - like
		- input: user data, community data
	- **user-user collaborative filtering**:
		- what most other users - with similar taste to you - like
		- input: user data, community data
	- **item-item collaborative filtering**:
		- input: user data, community data
	- **content based**:
		- what items are most similar to what you liked so far
		- input: user data, product features
	- **knowledge based**:
		- what fits your needs
		- input: user data, product features, knowledge model
	- **hybrid**:
		- combines all of the above

*terminology*

- system owner, content provider
- recommender system → estimates 'relevance' of items to users
	- recommender preferences
	- recommendation list → ranked list of 'relevant' items (match user preferences)
- user → receiver of recommendation
	- user profile → demographic data, feedback, preferences
	- user feedback → implicity: engagement, explicit: rating
	- user preferences → taste, intention towards items
- item → thing to be recommended
	- item content → text

*notation*

- assume: there are significantly more users than items, more items thans ratings
- $U$ user
	- $|U| \text= m$
- $I$ item
	- $|I| \text= n$
- $R$ rating
	- $r_{ui} \in R$ where $u \in U, i \in I$
- $s(u, i)$ score, predicted rating
	- $\hat{r}_{ui}$ with user as ‘target user, item as 'target item'

*evaluation*

- how close predicted rating/ranking is to user rating/ranking
	- rating prediction
	- classification accuracy
	- ranking accuracy
- online/offline evaluation
- managing data sparsity, cold starts

*cold start*

- new user:
	- non-personalized recommendations (popularity, demographics)
	- implicit feedback from random recommendations
- new item:
	- get item similarity through description
	- recommend to users with broad taste
- new system:
	- buy data
	- use knowledge based recommenders

*implicit vs. explicit feedback*

- **explicit feedback**:
	- is user-item rating in a matrix
	- less available, stronger signal
- **implicit feedback**:
	- is engagement (consumption data, clicks, page views, …) in a binary matrix
	- more available, weaker signal
	- has missing data:
		- set missing data to 0 in $R$ before training
		- make sure model doesn't always predict 0s for all missing ratings, 1s for all observed ratings
		- use customizable models like: weighted matrix factorization, bayesian personalized ranking

#  user-user colaborative filtering

- idea: predict rating of target item, by taking the average rating of all users **similar to target user**
- memory based: store entire user interaction history
- input:
	- user feedback, ratings in sparse **user-item matrix**
	- no content information

*predicted rating*

- **non personalized**:
	- get average rating of item, by all users (that have rated the item)
	- $\begin{aligned}U_i=\{u\in U|r_{ui}\in R\}\end{aligned}$
	- $\begin{aligned}s(u,i)=\frac{\sum_{v\in U_i}r_{vi}}{|U_i|}\end{aligned}$
- **weighted by similarity**:
	- same - but weigh more similar users heigher
	- $w_{uv} \in [\text-1, 1]$
	- $\begin{aligned}s(u,i)=\frac{\sum_{v\in U} {\color{violet}{w_{uv}}} \cdot r_{vi}}{\sum_{v\in U} |{\color{violet}{w_{uv}}}|}\end{aligned}$
- **unbiased**:
	- same - but consider their average rating (mean centering, since ie. a 10/10 can be interpreted differently)
	- $\begin{aligned} s(u,i)={\color{violet}\overline{r_u}}+\frac{\sum_{v\in U}w_{uv} \cdot {\color{violet}(r_{vi}- \overline{r_v})}}{\sum_{v\in U}|w_{uv}|} \end{aligned}$
- **neighborhood:**
	- same - but only consider subset of all users
	- $\begin{aligned} s(u,i)=\overline{r_u}+\frac{\sum_{v\in {{\color{violet} N(u)}} }w_{uv} \cdot (r_{vi}- \overline{r_v})}{\sum_{v\in {{\color{violet} N(u)}}}|w_{uv}|} \end{aligned}$

*user similarity: pearson correlation*

- users are similar, if they rate similarly
- we take the sum of all mutual rankings between 2 users, mean center and normalize to the $[\text-1;1]$ scale
	- correlation increases with frequency and intensity of agreement
	- problem: if users have just 1 common item, they are exactly similar
- $I_{u}=\{i\in I \mid r_{ui}\in R\}$
- $\begin{aligned} w_{uv}=\frac{\sum_{i\in I_u\cap I_v}(r_{ui}-\overline{r_u}) \cdot (r_{vi}-\overline{r_v})}{\sqrt{\sum_{i\in I_u}(r_{ui}-\overline{r_u})^2} \cdot \sqrt{\sum_{i\in I_v}(r_{vi}-\overline{r_v})^2}} \end{aligned}$

*user similarity: cosine similarity*

- pearson correlation is identical to 'mean centered' cosine similarity
- $\vec u$ = ratings vector for user $u$
- $\begin{aligned} w_{uv} = \cos(\vec{u},\vec{v})=\frac{\langle\vec{u},\vec{v}\rangle}{\|\vec{u}\|\cdot\|\vec{v}\|} = \frac{\sum_{i=1}^n u_i v_i}{\sqrt{\sum_{i=1}^n u_i^2}\cdot\sqrt{\sum_{i=1}^n v_i^2}}\end{aligned}$

*runtime optimization*

- $|U| \text= m$
- $|I| \text= n$
- runtime:
	- i) find neighbourhood of size $k$
		- computing similarity between two users: $O(n)$
		- computing pairwise similarity between all users: $O(nm^2)$ → very expensive
		- optimization: filter by users with at least 1 mutually rated item
	- ii) predict rating of a single item: $O(k)$
		- optimization: filter by users that have rated the item you want to predict the rating of
	- iii) return highest ranked item: $O(n)$

# item-item colaborative filtering

- idea: predict rating of target item, by taking the average of rating all items **similar to target item**
- memory based: store entire user interaction history
- advantages over uu-cf:
	- ‘item similarities’ are more stable than 'user similarities'
	- items have more ratings, than users give ratings
	- more efficient because there are less items than users
	- more effective
- disadvantages over uu-cf:
	- too obvious, because too similar to already rated ones
- input:
	- item rankings
	- no content information

*predicted rating*

- **non personalized**:
	- average rating of the target user
	- includes only items that got rated by 'target user'
	- $I_u=\{i\in I \mid r_{ui}\in R\}$
	- $\begin{aligned}s(u,i)=\frac{\sum_{j\in I_u}r_{uj}}{{\color{violet}|I_u|}}\end{aligned}$
- **neighborhood:**
	- weights $w_{ij}$ for how similar items rated by 'target user' are to the 'target item' we want to predict the rating of
	- $\begin{aligned}s(u,i)=\overline{r_i}+\frac{\sum_{j\in N(i)}w_{ij}(r_{uj}-\overline{r_j})}{\sum_{j\in N(i)}|w_{ij}|}\end{aligned}$

*item similarity: pearson correlation*

- items are similar, if they get rated by users similarly
- $U_i=\{u\in U|r_{ui}\in R\}$
- $\begin{aligned}w_{ij}&=\frac{\sum_{u\in U_i\cap U_j}(r_{ui}-\overline{r_i})\cdot (r_{uj}-\overline{r_j})}{\sqrt{\sum_{u\in U_i}(r_{ui}-\overline{r_i})^2}\cdot\sqrt{\sum_{u\in U_j}(r_{uj}-\overline{r_j})^2} }\end{aligned}$

*runtime optimization*

- $|U| \text= m$
- $|I| \text= n$
- runtime:
	- i) find item neighbourhood of size $k$
		- computing similarity between two items: $O(m)$
		- computing pairwise similarity between all items: $O(n^2m)$
		- optimization: only compare with items, that got rated by the same people that rated the 'target item'
	- ii) predict rating of a single item: $O(k)$
		- optimization: precompute and cache **offline model** of neighbours, because they change more slowly
	- iii) return highest ranked item: $O(n)$

# model-based collaborative filtering: matrix factorization

 model based: only store signals, not entire history (opposite of memory based)

*singular value decomposition SVD*

- can express any matrix as: $M = U \Sigma V^T$
- truncated SVD:
	- only keep the $k$ largest values in each factor: $\hat M = \hat U \hat  \Sigma \hat  V ^T$
	- low-rank matrix approximation with minimal errors (under squared root)
- apply 'truncated SVD' to user-rating matrix:
	- $\hat R = \hat U \hat  \Sigma \hat  V ^T$
	- $\hat r_{ui} = \sum_f \hat U_{uf} \cdot \hat\Sigma_{uf} \cdot \hat V_{if}$ = predicted ratings
	- $k$ = number of features that describe user preferences (ie. comedy, drama, …)
	- $\hat \Sigma$ = significance of features (weights)
	- $\hat U$ = user features (interests)
	- $\hat V$ = item features (descriptions)
	- issue: $R$ usually has missing values, so it's inaccurate and we might have to fill values in

*matrix factorization*

- truncate SVD of $R$, then remove $\hat \Sigma$
- $\hat R = P^T \cdot Q$
- $\hat r_{ui} = p_u^T q_i$
	- we have to learn new factors $P,Q$ with 'alternating least squares ALS' or 'stochastic gradient descent SGD'
	- $P$ = user features
		- one column vector per user
		- $p_u$ = vector of user $u$
	- $Q$ = item features
		- one column vector per item
		- $q_i$ = vector of item $i$
- describes latent feature space:
	- users, items described by embeddings / vectors
	- large inner product = better match = higher predicted rating

*stochastic gradient descent SGD*

- used to learn factors $P, Q$ in matrix factorization
- non-convex optimization problem: minimize the total cost function $J$
- **total cost function**:
	- $\theta \in \{P,Q\}$
	- $J(\theta)=\frac1{|R|}\sum_{r_{ui}\in R} {J^{(u,i)}(\theta)}$
		- $J^{(u,i)}$ = cost function for a single rating $\hat r_{ui}$
	- $J(\theta)=\frac1{|R|}\sum_{r_{ui}\in R} \underbracket{e_{ui}^2}  + \underbracket{\lambda(\|P\|^2+\|Q\|^2)}$
		- squared prediction error: ${e_{ui}^2}=(r_{ui}-p_u^\intercal q_i)^2$ → error on known ratings, training data
		- frobenius norm with parameter $\lambda$: ${\lambda(\|P\|^2+\|Q\|^2)~ }$ → error on unknown ratings, test data
	- $J(\theta)=\frac1{|R|}\sum_{r_{ui}\in R} \underbracket{(r_{ui}-p_u^\intercal q_i)^2} + \underbracket{\lambda\left(\sum_u\sum_fp_{uf}^2+\sum_i\sum_fq_{if}^2\right)}$
- **algorithm**:
	- 1) randomly shuffle ratings $R$
	- 2) randomly initialize ${P, Q}$
	- 3) update each parameter until convergence
		- $e_{ui} := r_{ui}-p_{u}^\intercal q_i$
		- $\theta:=\theta-\eta\cdot\frac{\partial J(\theta)}{\partial\theta}$
			- $q_i := \frac{\partial J^{(u,i)}}{\partial q_i}= q_i+\eta\cdot(e_{ui}\cdot p_u-\lambda\cdot q_i)$
			- $p_u := \frac{\partial J^{(u,i)}}{\partial p_u} = p_u+\eta\cdot(e_{ui}\cdot q_i-\lambda\cdot p_u)$
		- where:
			- $\theta \in \{P,Q\}$
			- $\frac{\partial J(\theta)}{\partial\theta}$ = gradient, derivative, slope of error function at a particular point
			- $\eta$ = learning rate

*improved matrix factorization*

no longer $\hat r_{ui} = p_u^T q_i$

$\hat{r}_{ui}=\underbrace{\mu+b_u+b_i}_{\text{baseline estimate}}    +    \underbrace{q_i^{\mathsf{T}}}_{\text{item model}}     \cdot {\left(\underbrace{p_u}_{\text{user model}}+   \underbrace{|N(u)|^{-\frac12}\sum_{j\in N(u)}y_j}_{\text{implicit feedback}}\right)}$

- **baseline estimate**:
	- reducing bias: we consider the average rating of each users (some are more critical than others)
	- $b_{ui}=\mu+b_i+b_u$ (baseline estimate)
		- $\mu$ = average rating, among all ratings
		- $b_i$ = bias in item ratings
		- $b_u$ = bias in user ratings
	- gradient descent shouldn't just learn $q_i, p_u$ but also $b_i, b_u$:
		- $b_u := b_u+\eta\cdot(e_{ui}-\lambda\cdot b_u)$
		- $b_i :=b_i+\eta\cdot(e_{ui}-\lambda\cdot b_i)$
- **implicit feedback:**
	- can be extended with other data by adding more feature vectors
	- $\sum_{j\in N(u)}y_j$ = implicit feedback feature vector
		- $N(u)$ = list of items that the user $u$ has engaged with
		- $|N(u)^{-\frac{1}{2}}|$ = normalizing sum of feature vectors

*weighted matrix factorization WMF (for implicit feedback)*

- $J(\theta)=\frac1{n \cdot m}\sum_{u,i}  \underbracket{w_{ui}} \cdot \underbracket{J^{(u,i)}(\theta)}$
- $J(\theta)=\frac1{n \cdot m}\sum_{u,i} \underbracket{w_{ui}} \cdot \underbracket{ e_{ui}^2+\lambda(\|P\|^2+\|Q\|^2)}$
- not just observed feedback like in previous 'matrix factorization' but also missing feedback: $|R| \not = n \cdot m$
- **confidence weight**: $w_{ui}$ for $r_{iu}$
	- errors are weighted higher, if we are more confident about the result
	- observed feedback: $w_{ui} = 1 + \alpha \cdot c_{ui}$
		- to avoid false positives: ie. user engaged a lot because they really didn't like it → measure frequency
		- $\alpha$ = significance
		- $c_{ui}$ = interaction count
	- missing feedback: $w_{ui}=w\cdot\frac{f_{i}^{\alpha}}{\Sigma_{j}f_{j}^{\alpha}}$
		- to avoid false negative: ie. no engagement, because they don't know it exists → measure exposure
		- $\alpha$ = significance
		- $w$ = fixed constant
		- $f_i$ = popularity of item $i$

*bayesian personalized ranking BMF (for implicit feedback)*

- goal: preference of item $i$ over item $j$ for user $u$ (because the prefered item is implicitly rated)
- $\hat x$ score
	- $\hat x_{uij} = (u,i,j)$ and $i > j$
	- $\hat{x}_{uij}=\hat{r}_{ui}-\hat{r}_{uj}$ and 
	- we learned the individual ratings $\hat r$ through some other model
- $\sigma$ = logistic function that maps to $[0;1]$, like sigmoid function
	- we want $\sigma(\hat{x}_{uij})=P(i>j)$
	- if item $i$ is prefered: $\hat{r}_{ui}>\hat{r}_{uj}$ → probability approaches 1
	- if item $i$ is not prefered: $\hat{r}_{ui}<\hat{r}_{uj}$ → probability aproaches 0

*point-wise learning vs. pair-wise learning*

- **point-wise learning**: better prediction accuracy (ie. 'weighted matrix factorization WMF')
- **pair-wise learning**: better ranking accuracy (ie. 'bayesian personalized ranking BMF')

# model-based collaborative filtering: factorization machines

*factorization machines*

- similar to 'matrix factorization'
- can encode multiple features for users and items
- can consider dependencies between features
- we want to **predict ratings** $r_{ui}$ **from multiple encoded attributes** $x^{ui}$
	- different ranges in columns from $x^{ui}$ stand for different features

*higher order linear regression*

- $\hat{r}_{ui}=\underbracket{\mu}_{(0)}+    \underbracket{\sum_p w_p \cdot x_p^{ui}}_{(1)} +      \underbracket{\sum_p\sum_{p^{\prime}\neq p}w_{pp^{\prime}}\cdot x_p^{ui} \cdot x_{p^{\prime}}^{ui}}_{(2)}$
- $\hat{r}_{ui}=\underbracket{\mu}_{(0)}+    \underbracket{b_u + b_i}_{(1)} +      \underbracket{p_u^T q_i}_{(2)}$
- 0th order:
	- $\mu$ = bias, global average rating
- 1st order:
	- learn weight $w_p$ of each feature $p$
- 2nd order:
	- learn interdependence weight $w_{pp'}$ for pair of features $p,~p'$
	- takes too long to compute
	- factorize $w_{pp^{\prime}}=v_p^\intercal v_{p^{\prime}}$ to latent vectors $v_p$ with $k$ dimensions to reduce number of weights that we learn

*sparse linear methods SLIM*

- assuming that weights are normalized, we can just get the sum of all ratings
	- $\hat{r}_{ui}=\sum_jw_{ij} \cdot r_{uj}$
	- $\hat R = RW$
- we want to learn the weight matrix $W$
	- $W = Q^T T$
	- $w_{ij}=q_i^\intercal \cdot y_j$
	- $\hat{r}_{ui}=\sum_j \underbracket{w_{ij}} \cdot r_{uj}$
	- $\hat{r}_{ui}= \sum_j  \underbracket{q_i^T \cdot y_j} \cdot r_{uj} = \underbracket{{  q_i^T}}_{\mathclap{\text{item}}} \cdot \underbracket{\sum_j r_{uj} \cdot { y_j}}_{\mathclap{\text{user}}}$

*restricted boltzmann machines RBM*

- $v$ = visible input/output layer
	- input: user rating vector, number of votes per star, length 5
	- output: probability for star rating
- $h$ = hidden layer
	- stochastic binary units (0/1 with some prob)
- $W, a, b$ = weights and biases
	- encode/decode binary representation
	- learned through 'contrastive divergence' (RBM learning)

*autoencoders AutoRec*

- shallow feed forward neural networks for unsupervised learning, trained with backpropagation / stochastic gradient decent SGD
- goal: making output match input
	- goal: $\hat{x}\equiv h_{W,b}(x)\thickapprox x$
	- can be item- or user-based
	- ie. item rating vector as input, predicted rating vector as output
- $W=\{W^{(1)},W^{(2)}\}$
- $b=\{b^{(1)},b^{(2)}\}$
- $L_1$ **layer: input**
	- $x = \{x_1,\dots,x_n, \mathbf 1\}$
	- same number of nodes as output
	- encodes input to low dimension embedding
- $L_2$ **layer: hidden**
	- $a^{(2)} = f(W^{(1)} \cdot x + b^{(1)})$
	- less nodes than input
	- $f$ is some activation function like sigmoid, tanh, relu
- $L_3$ **layer: output**
	- $h_{W,b}(x) = \hat x$
	- $\hat x = \{\hat x_1,\dots, \hat x_n\} \equiv h_{W,b}(x)=f(W^{(2)} \cdot a^{(2)}+b^{(2)})$
	- decodes embedding

*(collaborative) denoising autoencoders CDAE*

- for implcit feedback
- autoencoders that learn over: input with a lot of noise, user input
- output: predicted clicks of target user

*matrix factorization as neural network*

- assumption: no biases, linear activation
- input: $x$
	- 1-hot encoding of item
- hidden: $z = Qx$
- output: $y=P^\intercal z=P^\intercal Qx$
	- $y_u=P_u^\intercal Q_i=\hat{r}_{ui}$ → the $u$'th element in $y$ is the predicted rating of item $i$ for user $u$

# content based recommenders

- based on information retrieval ir
- no cold-start for items
- transparency, explainability
- user can land in 'filter bubble' and always get the same type of recommendation
- requires user feedback
- input:
	- only user feedback history, no collaboration
	- item content

*item content as vector represenation*

- document $d = \langle w_{1d},w_{2d},...,w_{nd}\rangle$
- $w_{td}$ = weight of term
- **1) turn into bag-of-words**
	- ignore order
- **2) apply "td-idf scheme"**
	- get word frequency, normalize with weights
	- $w_{t,d}=tf_{t,d} \cdot idf_t$
	- $tf_{t,d}=\begin{cases}\log_{10}(1+f_{t,d}),\quad&\text{if}\quad f_{t,d}>0\\0,\quad&\text{else}&\end{cases}$
		- $f_{t,d}$ = raw frequency of term in document
		- term frequency weight
		- frequency shouldn't be directly proportional to significance
	- $idf_t=\log_{10}\left(\frac N{df_t}\right)$
		- $N$ = number of documents
		- $df_t$ = number of documents with term
		- inverse document frequency weight
		- rare terms are more important
		- frequency should be seen relative to all documents (stop-words)

*k-nearest neighbors*

- cosine similarity:
	- $\begin{gathered}\cos(\vec{q},\vec{d})=\frac{\vec{q}\cdot\vec{d}}{|\vec{q}||\vec{d}|}=\frac{\vec{q}}{|\vec{q}|}\cdot\frac{\vec{d}}{|\vec{d}|}=\frac{\sum_{i=1}^{|V|}q_id_i}{\sqrt{\Sigma_{i=1}^{|V|}q_i^2}\sqrt{\Sigma_{i=1}^{|V|}d_i^2}}\end{gathered}$
	- $d_i$ = tf-idf weight of term $i$ in 'past rated item' (from user history)
	- $q_i$ = tf-idf weight of term $i$ in 'target item'
- neighborhood similarity
	- find $k$ neighbors of $q$ among list of $d$s
	- $\begin{gathered}\hat{r}_{uq}=\frac{\sum_{d\in N(q;u)}\cos(q,d)\cdot r_{ud}}{\sum_{d\in N(q;u)}\cos(q,d)}\end{gathered}$

*relevance feedback*

- past rated items of user split up in 2 sets:
	- positive feedback $D^+$
	- negative feedback $D^-$
- user profile vector (which we map items to):
	- $u=\alpha\cdot \underbracket{u_0}+\beta \cdot \underbracket{\frac1{|D^+|}\sum_{d^+\in D^+}d^+}-\gamma\cdot{\underbracket{\frac1{|D^-|}\sum_{d^-\in D^-}d^-}}$
	- where $u_0$ is some baseline vector for bias

# evaluation metrics

*before evaluation: k-fold cross validation*

- make $k$ partitions
- always use $1/k$ for dev data, others for train data
- train dataset
	- train - used to train model
	- dev - used to fine tune and find the right parameters
- test dataset
	- test - used to evaluate model

*prediction accuracy*

- measuring error between predicted vs. actual
- (root of) mean of squared errors RMSE
	- square so it penalizes variations harder
	- $e_{ui}=r_{ui}-\hat{r}_{ui}$
	- $\frac1{|R|}\sum_{r_{ui}\in R}|e_{ui}|$
- mean of absolute errors MAE
	- $\sqrt{\frac1{|R|}\sum_{r_ui\in R}e_{ui}^{2}}$

*classification accuracy*

- only true positives, false negatives
- precision P
	- $P = TP/(TP+FP)$
	- recommendations should be precise (don't recommend irrelevant items)
- recall P
	- $R = TP/(TP+FN)$
	- recommendations should be complete (don't miss relevant items)
- harmonic mean of precision and recal F1
	- $\small \begin{aligned}F_1=2\cdot\frac{P\cdot R}{P+R}=\frac2{\frac1P+\frac1R}\end{aligned}$

*ranking accuracy*

- weigh error based on rank
- should be computed for each user individually
- **precision P@k**:
	- precision of top $k$
- **recall R@k**:
	- recall of top $k$
- **average precision AP**:
	- average precision of top k relevant items
- **normalized discounted cumulative gain NDCG@k**:
	- how well we utilize the ranking system
	- actual:
		- $\text{IDCG}@k$
	- prediction:
		- $\begin{aligned}\text{DCG@}k=\sum_{j=1}^k\frac{r_{u,i_j}}{\log(j+1)}\end{aligned}$
		- $i_j$ = item $i$ at rank $j$
		- $r_{u,i_j}$ = relevance of item to target user
		- $\large \frac{r_{u,i_j}}{\log(j+1)}$ = discounted relevance, normalizes rating based on rank
	- normalized:
		- $\text{NDCG@}k=\frac{\text{DCG@}k}{\text{IDCG@}k}$

*online vs. offline*

- online: get metrics while system is running
- offline: get metrics from datasets
- user study: ui/ux research

*coverage*

- user coverage:
	- fraction of users that can be recommended to
	- cold start because of low confidence of predictions in the beginning
- item/catalog coverage:
	- fraction of items that can be recommended
- item/catalog coverage inequality:
	- accuracy grows for users and items with lots of feedback → tail heavy distribution
	- measure skew of distributeion
	- using: gini index, distribution divergence metrics

*user study metrics*

- trust: recommendation explainability
	- repetitive recommendations may make the system seem more reliable
- diversity: diversity in the recommendation list
- novelty/serendipity: diversity in the recommendation history of user

# sequence aware recommenders

*short-term vs. long-term interests*

- long-term interests: general taste
- short-term interests: intention while using system

*session aware vs. session based*

- session aware:
	- user identifiable through account or cookies
	- access to past user sessions
	- short-term + long-term interests
- session based:
	- user is anonymous
	- only access to this user session
	- short-term interests

*rich input, output*

- additional input:
	- user id
	- session id
	- interaction log = ordered sequence of many types of implicit feedback
- additional output (more interpretations):
	- alternatives choices
	- complementing choices
	- continuations (preequisites, follow ups)

*making conventional algorithms session aware*

- treat each session like a user
- **user-user cf**:
	- $\begin{aligned}\hat{r}(s,i)=\sum_{s^{\prime}\in N(s)}w_{s,s^{\prime}}\cdot \mathbb 1{(i\in s^{\prime})}\end{aligned}$
	- same as u-u-cf with implicit feedback
	- also called 'session-based kNN'
	- $N(s)$ = neighborhood of current session
	- $w_{s,s'}$ = session-session cosine similarity
	- $\mathbb 1{(i\in s^{\prime})}$ = neighborhoods that contain target item
- **item-item cf**:
	- $\begin{aligned}\hat{r}(s,i)=\sum_{j\in s}w_{i,j}\end{aligned}$
	- sum of similarities of all current session items
	- $w_{i,j}$ = item-item similarity
- **matrix factorization**:
	- $\hat{r}(s,i)=q_i^\intercal\sum_{j\in s}y_j{=\sum_{j\in s}q_i^\intercal y_j}$
	- $w_{ij}=q_i^\intercal \cdot y_j$
	- must be trained for each new session
	- session is represented by the $y$’s of the items it contains

*markov chains*

- sequence aware algorithm
- markov chain:
	- $p[\underbrace{S_{t+1}|S_t}_{\text{present}} = p[\underbrace{S_{t+1}}_{\text{future}} \mid \underbrace{S_1,\ldots,S_t}_{\text{past}}]]$
	- $S_t$ = state at time $t$
	- presence shows that past and future are conditionally independent. you can ignore history.
- probability of changing from $s$ to $s'$:
	- $p_{s,s^{\prime}}=p[S_{t+1}=s^{\prime}|S_t=s]$
	- how many times we see the transition happen ($s$ to $s'$) divided by how many times we see the initial state ($s$)
	- can be encoded in matrix
- recommendation: given the present, find the most likely future state

*recurrent neural networks*

- sequence aware algorithm
- can store state: RNN, LSTM, GRU

