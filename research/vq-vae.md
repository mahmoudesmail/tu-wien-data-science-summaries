> overview: https://lilianweng.github.io/posts/2018-08-12-vae/

*ae - autoencoder*

- https://www.youtube.com/watch?v=zp8clK9yCro
- https://www.cs.toronto.edu/~lczhang/360/lec/w05/autoencoder.html
- encoder-decoder neural networks
- unsupervised learning
- representation learning
- generative model
- other types:
	- denoising - decoder learns to reconstruct based on noisy data
	- sparse - a sparsity regulizer improves generaliziability and robustness
	- contractive - contractive space (representation space that is less sensitive to small perturbations in the input) regularizer, to improve robustness
- components:
	- **first half**: feature extractor
		- learning an encoding function to compress data
		- creates a latent representation / embedding
		- dimensionality reduction: usually data has some kind of structure and only uses a lower dimensional subspace of the full possible dimensionality of the input space. the network must learn a function to remap data to a lower dimension based on the structure of the data
	- **hidden layer**: bottleneck
		- the encoding / representation passed from the first half to the second half
		- you have to regularize this layer to reduce dimensionality
	- **second half**: denoiser
		- learning a decoding function to reconstruct the original input with minimal reconstruction error
		- `reconstruction error = Decoder(Encoder(X))`

*vae - variational autoencoders*

- https://www.youtube.com/watch?v=HBYQvKlaE0A (start watching from 23:44)
- https://towardsdatascience.com/understanding-variational-autoencoders-vaes-f70510919f73
- https://jaan.io/what-is-variational-autoencoder-vae-tutorial/
- enables us to generate realistic synthetic examples
- autoencoder that doesn't deterministically map $x$ to $z$ but samples $z$ from a stochastic model on $x$ that has been learned through variational inference
- components:
	- **probabilistic encoder**: approximation of distribution $q_\phi(z \mid x)$
		- $x$ = input (from data distribution)
		- $z$ = latent variables describing input (from latent distribution)
		- $q_\phi = q_\phi(z \mid x) \approx p_\theta (z \mid x)$ ⟶ approximation of target with variational inference
		- based on deterministic model $\phi$
		- generates distribution as: $\epsilon, \mu, \sigma$
	- **representation**: latent space $z$
	- **probabilistic decoder**: generation $p_\theta(x \mid z)$
		- $p^*(x)$ = actual distribution of input
		- $p_\theta(x)$ = learned conditional $\theta$ distribution of input
		- $p_\theta(z \mid x)$ = inference (input → latent)
		- $p_\theta(x \mid z)$ = generation (latent → input)
		- based on deterministic model $\theta$
		- has two loss functions:
			- $\mathcal{L}_{\text{recons}}$ = reconstruction error
			- $\mathcal{L}_{\text{KL}}$ = kullback–leibler divergence that regularizes to make sure that latent space has desirable properties

*vq-vae - vector quantized variational autoencoder*

- https://arxiv.org/pdf/1711.00937 (original paper)
- https://juliusruseckas.github.io/ml/vq-vae.html
- https://avdnoord.github.io/homepage/vqvae/
- https://www.youtube.com/watch?v=GgX_6Ce41-c
- https://www.youtube.com/watch?v=_GD18kRQk0A
- learns a discrete latent variable by the encoder, since discrete representations may be a more natural fit for problems like language, speech, reasoning, etc.
- the prior distribution is learned (as a categorical distribution) instead of being static (ie. a fixed normal distribution) after the discrete random variables are found
- components:
	- **encoder**:
		- $E(\mathbf x) = \mathbf z_e$
	- **representation**:
		- $\text{Quantize}(E(\mathbf x)) = \text{Quantize}(\mathbf z_e) = \mathbf{z}_q(\mathbf x) = e_k$
		- vector quantization VQ = mapping $K$-dimensional vectors into a finite set of predefined codebook-vectors
			- the nearest neighbor is chosen (ie. lowest euclidian distance)
			- $e_i$ where $i \in [1;K]$ = latent embedding space, codebook-vectors
	- **decoder**:
		- $p(x \mid z_q)$
		- the aggregated codebook-vectors are used to generate an output
		- loss functions:
			- reconstruction loss
			- VQ loss = L2 error between the embedding space and the encoder outputs
			- commitment loss = regularization to make encoder output more stable in quantization
	
