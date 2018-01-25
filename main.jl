##
# @author SwapnilB
##

include("dna.jl")

#########################################################################
# Composite type to store the genetic information of a given DNA sample
#########################################################################
function main()
	inputStr = ARGS[1]
	#inputStr = "Swapnil Borse"
	mutationRate = parse(Float64,ARGS[2])
	inputLength = length(inputStr)
	popArr, totalFitness = createPopulation(inputStr)
	popArr = calculateNormalizedFitness(popArr, inputLength)
	matingPool = createMatingPool(popArr)
	child = ""
	while child != inputStr
		par1, par2 = getParents(matingPool)
		child = getChild(par1, par2)
		if mutationRate > 0
			child = mutateChild(child, mutationRate)
		end
		child = calculateFitness(child, inputStr)
		push!(popArr, child)
		matingPool = addChildToMatingPool(matingPool, child)
		println(child.gene)
	end
end


#########################################################################
#
#########################################################################
function mutateChild(child, mutationRate)
	for i = 1:length(child.gene)
		if mutationRate > rand()
			#child.gene[i] = "$(Char(rand(65:122)))"
			replace(child.gene, child.gene[i], "$(Char(rand(65:122)))")
		end
	end
	child
end

#########################################################################
#
#########################################################################
function addChildToMatingPool(matingPool, child)
	for j = 1:child.normalisedFitness
		push!(matingPool, child)
	end
	matingPool
end


#########################################################################
#
#########################################################################
function calculateFitness(child, inputStr)
	fitness = 0
	for i = 1:length(inputStr)
		if child.gene[i] == inputStr[i]
			fitness = fitness + 1
		end
	end
	child.fitness = fitness
	child.normalisedFitness = trunc(Int, (child.fitness/length(inputStr))*100)
	child
end

#########################################################################
#
#########################################################################
function getChild(par1, par2)
	child = ""

	# Method 1 of reproduction
	#=
	shift = true
	for i = 1:length(par1.gene)
		if shift == true
			child = child * "$(par1.gene[i])"
			shift = false
		else
			child = child * "$(par2.gene[i])"
			shift = true
		end
	end
	=#
	#child = "$(par1.gene[1:trunc(Int,length(par1.gene)/2)])"
	#child = child * "$(par2.gene[trunc(Int,length(par1.gene)/2)+1: length(par1.gene)])"
	gene1 = par1.gene
	gene2 = par2.gene
	child = gene1[1:trunc(Int,length(gene1)/2)]
	child = child * gene2[trunc(Int,length(gene2)/2)+1: length(gene2)]
	childDNA = DNA(child,0,0)
	childDNA
end

#########################################################################
# Composite type to store the genetic information of a given DNA sample
#########################################################################
function getParents(matingPool)
	matingPool[rand(1:size(matingPool,1))],matingPool[rand(1:size(matingPool,1))]
end


#########################################################################
# function to create a mating pool from given population array
#########################################################################
function createMatingPool(popArr)
	matingPool = []
	for i = 1 : size(popArr,1)
		if popArr[i].normalisedFitness == 0
			push!(matingPool, popArr[i])
		else
			for j = 1 : popArr[i].normalisedFitness
				push!(matingPool, popArr[i])
			end
		end
	end
	matingPool
end


#########################################################################
# Function to create a random population sample
#########################################################################
function createPopulation(inputStr)
	populationArr = DNA[]
	totalFitness = 0
	for i = 1:500
		popSample = ""
		for i = 1:length(inputStr)
			choice = trunc(Int,rand()*10)%11
			if choice > 7
				popSample = popSample * " "
			else
				tempChar = randstring(1)
				while all(isnumber, tempChar) == true
					tempChar = randstring(1)
				end
				popSample = popSample * tempChar
			end
		end
		fitness = 0
		for j = 1:length(inputStr)
			if popSample[j] == inputStr[j]
				fitness = fitness + 1
			end
		end
		totalFitness = totalFitness + fitness
		dnaSample = DNA(popSample,fitness,0)
		push!(populationArr, dnaSample)
	end
	populationArr, totalFitness
end

#########################################################################
# Function to calculate normalised fitness for the gene samples
#########################################################################
function calculateNormalizedFitness(popArr, len)
	for i = 1:length(popArr)
		popArr[i].normalisedFitness = trunc(Int, (popArr[i].fitness/len)*100)
	end
	popArr
end

#########################################################################
# the main function
#########################################################################
main()
