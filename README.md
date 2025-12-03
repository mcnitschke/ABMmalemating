# ABMmalemating
Code for ABM model for evolution of male mating strategies in the human lineage.  All code related to the manuscript entitled "The male-biased sex ratio in humans and its role in the transition from promiscuity to pair bonding".
All code provided in in Matlab.

We constructed an Agent-Based model of male mating strategies, given various parameters that affect the viablility of each.  The strategy that succeeds is the strategy that produces the most offspring.  

Two main files to produce the data in the manuscript.
1. Out_1.m
2. Out_pvchi_human.m

Both use the same Middle.m file which contains all of the birth/death subfiles.  This includes
1. AgingMaturation.m -- Each individual goes through a process of aging and children mature over time.  Individual steps represnet one year of time
2. Conception -- 
3. Death -- At a fixed rate, individuals die and are removed from the population.
4. Breakup -- At a fixed rate, pairs break up.
5. CarryingCapacity -- A carrying capacity is set by the user.  When the maximum is reached, individuals are randomly removed.  
