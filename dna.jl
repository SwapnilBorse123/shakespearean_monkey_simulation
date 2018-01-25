#########################################################################
# Composite type to store the genetic information of a given DNA sample
#########################################################################
mutable struct DNA
	gene
	fitness::Int64
	normalisedFitness::Int64
end
