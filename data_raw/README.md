# Raw data

### NC_PIPPN_2022_02_01_1HA.csv

Tree inventory in twenty one 1-ha (100 m x 100 m) plots located in New Caledonia. All trees with a diameter at breast height >= 10 cm were measure and identifier.

| Column name | Description |
|:----------|:----------|
| Locality | name of the plot |
| Longitude | longitude of the plot (decimal degree) |
| Latitude | latitude of the plot (decimal degree) |
| Year | year of the inventory |
| Name | taxa name |
| Family | family name |
| Genus | genus name |
| DBH | diameter at breast height |

### Fruits_size_plot_NC.csv

Fruit, seed, and diaspore description for all tree species inventoried at least once in a network of twenty one 1-ha (100 m x 100 m) forest plots in New Caledonia.

| Column name | Description |
|:----------|:----------|
| Family | family name |
| Name | taxa name |
| Name_in_reference | name in the reference |
| Recorder | who entered the data |
| Reference | where the data comes from |
| Status | endemic or native |
| Fleshy_fruit | 1 = yes |
| Dehicent_fruit | 1 = yes |
| Fleshy_appendage | 1 = yes |
| Attractive_color | 1 = yes |
| Flight_appendage | 1 = yes |
| Fruit_type | berry, capsule, cone, dehicent fruit, drupe, dry fruit, figue, fleshy fruit, follicle, nut, pod, samara |
| Diaspore | which of the fruit or the seed is the diaspore |
| Syndrome | diespersal syndrome, either anemochory, barochory, endozoochory, hydrochory or mixte |
| Fruit_d1_min ... | fruit dimension |
| Fruit_dim_unit | unit used in the reference |
| Seed_d1_min ... | seed dimension |
| Seed_dim_unit | unit used in the reference |
| Seed_per_fruit_min ... | number of seeds per fruit |

### Cons_obs_NC.csv

Observations of fruit or seed consumption by birds in New Caledonia from various sources

| Column name | Description |
|:----------|:----------|
| Bird_name | taxa name of the bird who consumed the seed or fruit |
| Plant_name | taxa name of the plant consumed by the bird |
| Plant_name_in_reference | taxa name of the plant in the reference |
| Plant_genus | genus name of the plant |
| Plant_family | family name of the plant if genus unknown |
| Reference | where the observation comes from |
| Ref_type | type of reference, either academic report, book, flora, herbarium, online photo, personal communication,published paper, or technical report |

### Fruits_size_cons_NC.csv

Same as "Fruits_size_plot_NC" but for plant species not present in the 1-ha plots inventories but for which an observation consumption by a bird is available.

### Birds_NC.csv

Description of the terrestrial birds that potentially play a role in plant dispersion in New Caledonia.

| Column name | Description |
|:----------|:----------|
| Bird_name | taxa name of the bird |
| Order | order name of the bird |
| Family | family name of the bird |
| Common name | common English name (and local name) |
| Origin | either endemic genus, species, or subspecies, introduced, native |
| Status | conservation status (CR = critically engendered, EX = extinct, LC = least concerned, LEX = locally extinct, NT = near threatened, VU = vulnerable) |
| Fruits, ..., Reptiles | diet (1 = yes) |
| *Body_size | body size (beak to tail) in mm |
| **Beak_length_culmen, ..., Tail_length | bird morphology mm |
| **Mass | bird mass in g |
| Comment | additional comments |

* from Duston (2011)
** from AVONET (Tobias et al., 2022)

Dutson, Guy C. L. Birds of Melanesia: The Bismarcks, Solomons, Vanuatu and New Caledonia. Christopher Helm, 2011.

Tobias, Joseph A., Catherine Sheard, Alex L. Pigot, Adam J. M. Devenish, Jingyi Yang, Ferran Sayol, Montague H. C. Neate-Clegg, et al. « AVONET: Morphological, Ecological and Geographical Data for All Birds ». Ecology Letters 25, nᵒ 3 (2022): 581‑97. https://doi.org/10.1111/ele.13898.













