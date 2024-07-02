# chapter 1

**question**: which of the following statements about attention in visual processing are true?

- a) attention is important in determining what information is retained from visual input.
- b) attention in contextualized representations allows models to dynamically focus on relevant parts of input, unlike humans who can focus on multiple things simultaneously without any selectivity.
- c) visual queries, which are acts of attention driving eye movements, are important to consider in visualization design.
- d) inattentional blindness demonstrates that visual changes can NEVER go unnoticed, even if humans don't concentrate at all.

answer:

- a) true
	- attention drives what information we retain from visual input
- b) false
	- the first part of the question is (true but) unrelated to information visualization
	- the second part of the question is false, because attention is all about selective perception since humans can't focus on too many things at once
- c) true
	- visual queries are described as "acts of attention driving our eye-movements"
- d) false
	- inattentional blindness actually demonstrates the opposite - that without attention, even significant visual changes can go unnoticed

---

**question**: which of the following statements best describes the concept of visual channel expressiveness in data visualization?

- a) how well a human can carry out a task with a given visual representation
- b) the number of data points that can be displayed using a particular visual channel
- c) the potential for channel mismatch when encoding data inappropriately
- d) the type of information that can or cannot be expressed with a channel

answer: 

- a) false
	- this is describing effectiveness, not expressiveness.
	- effectiveness = how well a channel can express information.
	- expressiveness = which types of information can be expressed by a channel (ie. quantitative, sequential, categorical data)
- b) false
	- this is describing capacity or scalability, not expressiveness.
- c) true
	- a channel mismatch happens when data is encoded using the wrong channel, leading to misinterpretation / unintended implications
- d) true
	- based definition from lecture: "Expressiveness is about the type of information that can or can't be expressed by a channel."

---

**question**: which of the following statements is true about how visual stimuli are processed by humans?

- a) the fovea provides high-resolution vision in a small area, about the size of a thumbnail at arm's length.
- b) visual processing occurs in stages, with early stages detecting low-level features like color and orientation in parallel and later stages.
- c) saccadic eye movements allow us to rapidly sample information from different parts of a scene that get stitched together in our cognitive system.
- d) attention plays a very important role in determining what visual information is retained and processed further.

answer:

- a) true - the fovea is a small region of the retina with the highest density of cone cells, providing sharp central vision
- b) true - the visual system processes information hierarchically, from simple features to more complex representations
- c) true - saccades help us quickly scan a scene, with the brain integrating information from multiple fixations
- d) true - attention acts as a filter to select the most relevant information for further processing.

---

**question**: when evaluating visualization designs, which of the following approaches are recommended?

- a) explicitly identify the tasks the visualization is meant to help accomplish
- b) consider the visual queries needed to answer specific questions
- c) compare how easily different designs and visual channels support relevant visual queries
- d) focus solely on the aesthetic appeal of the visualization

answer:

- a, b, c) true
	- the evaluation of visualizations is essentially an information retrieval task
	- the first step in evaluating visual designs is making tasks and the corresponding visual queries explicit, then considering the visual queries needed to answer specific questions and finally comparing how easily different designs support retrieving information for the given queries
- d) false
	- aesthetic appeal is subjective and not a universal way to evaluate visualizations
	- although research has shown that aesthetics can influence the perceived usability of data visualizations (see: https://www.researchgate.net/publication/4261021_The_Effect_of_Aesthetic_on_the_Usability_of_Data_Visualization)

---

**question**: why might inattentional blindness be particularly problematic for data visualization?

- a) it prevents users from seeing preattentive features
- b) it can cause users to miss important changes or patterns in the data
- c) it reduces the effectiveness of color as a visual channel
- d) it limits the number of visual queries a user can perform

answer:

 - a) false
	 - preattentive feature perception isn't affected.
- b) true
	- users might miss important information if their attention is focused elsewhere.
	- the attention of the observers must be guided to the most important graphical or symbolic elements.
- c) false
	- color perception isn't affected.
- d) mostly false
	- it doesn't directly limit the number of visual queries, but may affect their effectiveness.

---

**question**: which of the following is not a valid reason for why humans perceive they have full awareness of their visual field despite only seeing a small portion in high resolution?

- a) saccadic eye movements
- b) attention-driven perception
- c) the world acting as its own memory
- d) the fovea expanding under cognitive load

answer:

- a) true - saccadic movements allow rapid sampling of the visual field
- b) true - attention helps focus on relevant information
- c) true - the world acts as an external memory store
- d) false - the fovea does not expand under cognitive load

---

**question**:  which of the following is NOT a characteristic of low-level vision processing in areas v1 and v2 of the brain?

- a) parallel processing
- b) detection of complex semantic meanings
- c) tuning to specific visual properties
- d) rapid, unconscious processing

answer:

- a) false - characteristic of v1 and v2 processing.
- b) true - complex semantic processing occurs in higher-level brain areas, not v1 and v2.
- c) false - characteristic of v1 and v2 processing (they're called tunable properties)
- d) false - characteristic of v1 and v2 processing.

---

**question**: which of the following would be the MOST effective way to represent a 7-point likert scale (hint: ordinal data) in a visualization?

- a) 7 different shapes
- b) a continuous color gradient
- c) 7 distinct positions on an axis
- d) 7 different textures

answer:

- a) false - shapes are categorical but not inherently ordered.
- b) false - a continuous gradient isn't suitable for discrete data.
- c) true - position is highly effective for ordered and discrete data.
- d) false - textures can show order but are less effective than position.

---

**question**: how might understanding the concept of "visual queries" impact visualization design?

- a) it would lead to designs with more preattentive features
- b) it would encourage designs that support specific user tasks
- c) it would result in visualizations with higher data density
- d) it would promote the use of more color in visualizations

answer:

- a) false - it's possible but not a definite outcome
- b) true - it changes how we evaluate visualizations and optimizes for supporting users in their tasks
- c) false - higher data density isn't always the goal of understanding visual queries
- d) false - color use isn't directly related to understanding visual queries

---

**question**: which of the following statements about expressiveness in visualization is false?

- a) expressiveness refers to what type of information a channel can represent
- b) a channel that can express quantities can always express categories
- c) color hue is expressive for categorical data but not for quantitative data
- d) position is generally the most expressive channel for most types of data

answer:

- a) true
	- this is the definition
- b) false
	- channels suited for quantities aren't always good for categories.
- c) true
	- color hue is indeed better for categories than quantities
	- a multi-hue sequential color scale improves discriminability because we span a larger volume of the color space
- d) true
	- position is generally considered the most versatile and expressive channel.

# chapter 2

**question**: which of the following are properties that describe the effectiveness of a visual channel?

- a) accuracy
- b) expressiveness
- c) discriminability
- d) salience

answer:

- a, c, d) true
	- channel effectiveness can be understood as:
		- accuracy (single) = accuracy in expressing magnitudes, quantity
		- discriminability (single) = number of distinguishable values
		- salience / pop-out (multiple) = attracting attention, standing out from redundancy
		- seperability (multiple) = tuning attention, especially during conjunctive search (multiple channels used to encode at once)
		- grouping (multiple) = grouping and pattern information
			- gestalt laws = graphical objects grouped to create a pattern through: proximity, similarity, connection, enclosure, closure, continuity (some are stronger than others)
- b) false
	- effectiveness = how well a channel can express information.
	- expressiveness = which types of information can be expressed by a channel (ie. quantitative, sequential, categorical data)

---

**question**: in a conjunctive visual search task, which combination would likely be the slowest for viewers to process?

- a) red circles among blue circles and red squares
- b) large blue shapes among small blue shapes and large red shapes
- c) parallel lines among perpendicular lines of various colors
- d) smiling face emojis among frowning face emojis of various colors

answer:

- a, b, d) false - these combine pre-attentive features that can be processed quickly.
- c) true - neither line orientation nor color alone distinguishes the target, requiring serial search.

---

**question**: based on the gestalt laws, which visualization technique would likely be LEAST effective for grouping related data points?

- a) using a common color for related points in a scatter plot
- b) enclosing related points within a contour line
- c) connecting related points with lines
- d) spacing related points slightly farther apart than unrelated points

answer:

- a, b, c) false - basic principles: similarity, enclosure and connection.
- d) true - increased spacing contradicts the proximity principle and would likely be least effective for grouping.

---

**question**: according to stevens' power law, which visual channel would likely lead to the most accurate perception of quantitative differences?

- a) area of circles
- b) length of bars
- c) angle of pie chart slices
- d) color saturation

answer:

- a, c, d) false - these channels tend to result in under-estimateion or over-estimation of quantities.
- b) true - length typically has an exponent close to 1 in stevens' power law, leading to more accurate perception.

---

**question**: which visualization technique would be LEAST suitable for representing data with high cardinality (many distinct values)?

- a) a heat map using color intensity
- b) a scatter plot using position
- c) a bar chart using length
- d) a bubble chart using size

answer:

- a, b) false - heat maps and scatter plots can represent many distinct values effectively.
- c) false - bar charts can handle moderately high cardinality.
- d) true - size (area) has limited discriminability and is least suitable for high cardinality data as once the bubbles representing magnitude grow large enough they usually start overlapping.

---

**question**: based on the principle of visual separability, which pair of channels would be most difficult for visualization observers to perceive independently?

- a) color and shape
- b) size and position
- c) orientation and texture
- d) width and height of rectangles

answer:

- a, b, c)  false - these pairs are generally separable and can be perceived independently.
- d) true - width and height of rectangles are integral dimensions and difficult to perceive separately.

---

**question**: which gestalt principle is most likely being violated in a node-link diagram where strongly related nodes are positioned far apart?

- a) similarity
- b) closure
- c) proximity
- d) continuity

answer:

- a, b, d) false - these pairs don't have anything to do with the spacial layout of data.
- c) true - the principle of proximity is violated when strongly related nodes are far apart.

---

**question**: based on the concept of salience / pop-out, which technique would be LEAST effective for highlighting important data points in a crowded scatter plot?

- a) increasing the size of important points
- b) changing the color of important points to red, while changing others to gray-scale
- c) enclosing important points in a contour
- d) slightly increasing the opacity of important points

answer: 

- a, b, c) false - these techniques effectively increase salience and draw attention.
- d) true - a slight increase in opacity is subtle and would likely be the least effective for highlighting points in a crowded plot.

# chapter 3

**question**: based on the trichromacy theory and the structure of the human eye, why might digital displays use red, green, and blue as their primary colors?

- a) because these are the only colors humans can see
- b) to match the three types of cone cells in the human eye
- c) because these colors are the easiest to produce electronically
- d) to maximize the range of reproducible colors

answer:

- a) false - humans don't just see the colors red, green, and blue.
- b) true - to match the three types of cone cells in the human eye, the three types of cones in the human eye are sensitive to short (blue), medium (green), and long (r- d) wavelengths, which aligns with the rgb color model used in displays.
- c) false - while this might be true, it's not the primary reason based on the information provided.
- d) false - while this is a benefit, it's not the primary reason based on the trichromacy theory discussed in the slides.

---

**question**: in a visualization of disease prevalence changes over time, you notice it's difficult to distinguish between positive and negative changes. what might be the underlying issue?

- a) the color space used is not perceptually uniform
- b) the visualization is using too many colors
- c) the color encoding doesn't account for the sign of the change
- d) the monitor's color calibration is incorrect

answer:

- a) false - could be an issue but not the primary problem.
- b) false - the number of colors wasn't mentioned as an issue.
- c) true - the color encoding doesn't account for the sign of the change. diverging color scales could be helpful.
- d) false - possible, but this wouldn't affect all viewers.

---

**question**: based on the opponent process theory, which of the following color combinations would be IMPOSSIBLE for humans to perceive?

- a) reddish-orange
- b) yellowish-green
- c) bluish-red
- d) greenish-red

answer:

- a) false - possible color combination.
- b) false - possible color combination.
- c) false - this would be an unconventional way to describe purple.
- d) true - according to the opponent process theory, we never describe colors as reddish-green or greenish-red, as these are opposite ends of the same perceptual channel.

---

**question**: if you were designing a color picker for artists, which color space would be most appropriate to use?

- a) rgb
- b) hsv
- c) cie lab
- d) hcl

answer:

- a) false - rgb is not intuitive for specifying colors.
- b) true - hsv is very intuitive and natural for specifying colors, making it ideal for artists who think in terms of hue, saturation, and value.
- c) false - while perceptually uniform, cie lab is not as intuitive as hsv for artistic purposes.
- d) false - while hcl is both uniform and relatively intuitive, hsv is more commonly used and understood by artists.

---

**question**: if you were designing a visualization for people with red-green color blindness, which of the following strategies would be LEAST effective?

- a) using a blue to yellow color scale
- b) employing patterns in addition to colors
- c) utilizing variations in lightness
- d) relying on red and green hues to encode critical information

answer:

- a) false - this would be effective as blue-yellow is a different perceptual channel from red-green.
- b) false - this would be an effective strategy to convey information beyond color.
- c) false - variations in lightness would be perceivable regardless of color blindness.
- d) true - this would be the least effective strategy, as people with red-green color blindness would struggle to distinguish these hues.

---

**question**: in the context of color perception, why might the fovea be particularly important for detailed color vision?

- a) it contains only rod cells
- b) it has a higher density of cone cells
- c) it is where the optic nerve connects to the retina
- d) it is the only part of the eye sensitive to color

answer:

- a) false - the fovea actually contains primarily cone cells, not rod cells.
- b) true - the fovea has a much higher density of cone cells, which are responsible for color vision and detailed sight.
- c) false - this describes the blind spot, not the fovea.
- d) false - while the fovea is crucial for detailed color vision, other parts of the retina are also sensitive to color.

---

**question**: based on the opponent process theory, which of the following afterimage effects would you expect to see after staring at a bright red object for an extended period?

- a) a red afterimage
- b) a green afterimage
- c) a blue afterimage
- d) a yellow afterimage

answer:

- a, c, d) false
- b) true
	- the afterimage is typically the opposite color on the opponent process channel.
	- according to the opponent process theory, red and green are on opposite ends of one perceptual channel, so staring at red would produce a green afterimage.

---

**question**: if you were designing a color scale for a visualization that needed to represent both positive and negative values, which of the following approaches would likely be most effective?

- a) a single-hue scale from light to dark
- b) a rainbow scale
- c) a diverging scale with different hues for positive and negative values
- d) a grayscale

answer:

- a) false - this wouldn't effectively distinguish between positive and negative values.
- b) false - rainbow scales are often criticized for being perceptually non-uniform and hard to interpret.
- c) true - this would allow for clear distinction between positive and negative values while also showing magnitude.
- d) false - while this could show magnitude, it wouldn't easily distinguish between positive and negative values.

# chapter 4

**question**: in a visualization using a diverging color scale to represent election data, what unexpected effect might occur if the midpoint is not carefully chosen?

- a) voters may perceive a bias in the data presentation
- b) color blind viewers will be unable to interpret the results
- c) the scale will fail to show any meaningful differences
- d) extreme values will be indistinguishable from each other

answer:

- a) true - an improperly chosen midpoint could make one party's results appear more dominant, creating a perceived bias.
- b) false - color blindness issues are separate from midpoint selection.
- c) false - the scale would still show differences, just potentially in a biased way.
- d) false - extreme values would still be distinguishable, though potentially biased.

---

**question**: how might the principle of color constancy be exploited to create an optical illusion in a data visualization?

- a) by using adjacent colors to make identical shades appear different
- b) by employing highly saturated colors for small data points
- c) by using a multi-hue sequential scale instead of a single-hue scale
- d) by applying a diverging color scale to categorical data

answer:

- a) true - color constancy could make identical colors appear different when placed on different backgrounds.
- b) false - this relates to the effect of size on color perception, not color constancy.
- c) false - this is unrelated to color constancy.
- d) false - this would be an inappropriate use of a diverging scale, unrelated to color constancy.

---

**question**: in a time-series visualization using color to represent change, how could "change blindness" be accidentally induced?

- a) by using colors that are too similar for adjacent time periods
- b) by using a diverging color scale instead of a sequential one
- c) by using highly saturated colors throughout the visualization
- d) by including too many data points in the time series

answer:

- a) true - low contrast / very similar / hard to distinguish colors between time periods could make changes hard to notice.
- b) false - diverging color scales = hue based on whether values are above/below a threshold (ie. positive, negative) → the color scale type doesn't directly relate to change blindness, rather how easy to distinguish the colors are to guide the observers attention
- c) false - saturation levels don't typically induce change blindness.
- d) partially true - too many data points could make individual changes harder to notice - but it actually depends on the capacity or scalability of the visual channel

---

**question**: how might the principle of using color for "highlighting/emphasis" backfire in a complex, multi-variable visualization?

- a) it could create unintended visual hierarchies
- b) it might cause "attentional blink" in rapid data processing
- c) it could lead to misinterpretation of data relationships
- d) all of the above

answer:

- a) false - when graphical elements capture multiple variables at once, unintended emphasis is likelier
- b) false - in complex visualizations, highlighted elements might cause viewers to miss subsequent important information. - this wasn't actually discussed in the lectures, but i found it interesting (see: https://en.wikipedia.org/wiki/Attentional_blink)
- c) false - emphasis through color could suggest relationships between variables that don't actually exist.
- d) true - all these issues could potentially occur when using color for emphasis in complex visualizations.

**question**: in designing a visualization for a global audience, which unexpected factor might influence your color choices beyond cultural associations and color blindness considerations?

- a) the average age of your target audience
- b) the most common digital device used in each region
- c) the predominant climate of each geographical area
- d) the level of air pollution in major cities

answer:

- a) true - age can affect color perception, with older adults often having difficulty distinguishing certain colors.
- b) partially true - different devices may display colors differently, affecting perception.
- c) false - climate doesn't directly affect color perception in visualization design.
- d) false - while air pollution can affect visibility, it's not a consideration in digital visualization design.

---

**question**: how might the concept of "discriminability" in color scales be challenged when designing a visualization meant to be viewed on both mobile devices and large projection screens?

- a) mobile devices may not accurately reproduce subtle color differences
- b) projection screens may wash out certain colors, reducing contrast
- c) viewing distance may affect the perception of color differences
- d) all of the above

answer:

- a) false - mobile screens may have limited color reproduction capabilities.
- b) false - projection systems often have lower contrast ratios, affecting color perception.
- c) false - viewing distance can affect the ability to distinguish between similar colors.
- d) correct - all of these factors can challenge color discriminability across different viewing scenarios.

---

**question**: in a multi-layered visualization, how might the strategic use of gray inadvertently create an accessibility issue?

- a) it may reduce contrast for viewers with low vision
- b) it could create confusion for color blind users
- c) it might unintentionally emphasize less important information
- d) it could make the visualization appear outdated

answer:

- a) true - overuse of gray could reduce overall contrast, making it difficult for low vision users.
- b) partially true - depending on the shades used, it could potentially cause issues for some color blind users.
- c) true - if not used carefully, gray elements might draw more attention than intended.
- d) false - the use of gray doesn't inherently make a visualization look outdated.

---

**question**: in designing a categorical color scale for a global brand, how might trademark laws unexpectedly influence your color choices?

- a) certain color combinations might be protected by competing brands
- b) some cultures may have legal restrictions on the use of certain colors
- c) international color standards may limit available choices
- d) printer ink availability could restrict usable colors

answer:

- a) correct - some brands have trademarked specific colors or color combinations.
- b) false - while cultural associations are important, there are generally no legal restrictions on colors.
- c) false - international color standards don't typically limit color choices in this way.
- d) false - printer ink availability doesn't generally affect digital color choices for branding.

---
