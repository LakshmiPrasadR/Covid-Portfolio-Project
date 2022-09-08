# Business case.
Is the movie industry dying? is Netflix the new entertainment king? This dataset is focused on movie revenue over the last decades. But, why stop there? There are more factors that intervene in this kind of thing, like actors, genres, user ratings and more. And as we dig more in to the data , we try to answer specific questions about the movie industry understand the correlation between the variables, by analyzing and visualizing them.

# Dataset
There are 6820 movies in the dataset (220 movies per year, 1986-2016). Each movie has the following attributes:

- budget: the budget of a movie. Some movies don't have this, so it appears as 0

- company: the production company

- country: country of origin

- director: the director

- genre: main genre of the movie.

- gross: revenue of the movie

- name: name of the movie

- rating: rating of the movie (R, PG, etc.)

- released: release date (YYYY-MM-DD)

- runtime: duration of the movie

- score: IMDb user rating

- votes: number of user votes

- star: main actor/actress

- writer: writer of the movie

- year: year of release

# Approach:
The dataset was analyzed using the Jupyter Notebook.
Libraries in Python like **NumPy**, **Pandas** were used for basic calculations and EDA 
Libraries like **SeaBorn** and **Matplotlib** were used to establish, understand and visualize the Statistical **correlation** between the variables.

# Few insights observed 
- The **scatter-plot** between Score variable and Gross revenue variable shows a positive relation.
- There is a high correlation between **Budget and Gross** shown from scatter plot using Pearson method.
- **Heatmap** explains the Correlation matrics between all the numerical variables.
- The **Company** variable has the lower correlation with other variables.

- Check the complete Code with Visuals [here](https://github.com/LakshmiPrasadR/Portfolio-Projects/blob/main/Movie%20Correlation%20Project.ipynb)









