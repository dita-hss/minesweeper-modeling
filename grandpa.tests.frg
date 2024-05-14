#lang forge/bsl

open "grandpa.frg"
// DO NOT EDIT above this line  

------------------------------------------------------------------------

test suite for FamilyFact {
    example noSelfMarriage is {not FamilyFact} for {
        Person = `Person1
        `Person1.spouse = `Person1
    }

    example noSelfAncestry is {not FamilyFact} for {
        Person = `Person1
        `Person1.parent1 = `Person1
    }

    example correctSpousalRelationship is {FamilyFact} for {
        Person = `Person1 + `Person2
        `Person1.spouse = `Person2
        `Person2.spouse = `Person1
    }

    example noAncestryBetweenSpouses is {not FamilyFact} for {
        Person = `Person1 + `Person2
        `Person1.spouse = `Person2
        `Person2.parent1 = `Person1
    }

    example distinctAncestryLines is {not FamilyFact} for {
        Person = `Person1 + `Parent1 + `Parent2
        `Person1.parent1 = `Parent1
        `Person1.parent2 = `Parent2
        `Parent2.parent1 = `Parent1
    }

    example noCommonAncestorBetweenPersonAndSpouse is {not FamilyFact} for {
        Person = `Person1 + `Person2 + `Ancestor
        `Person1.spouse = `Person2
        `Person1.parent1 = `Ancestor
        `Person2.parent1 = `Ancestor
    }
}


test suite for ownGrandparent {
    example ownGrandparentExample is {ownGrandparent} for {
        Person = `Narrator + `OlderWoman + `StepDaughter + `Father
        no `OlderWoman.parent1
        no `OlderWoman.parent2
        no `Father.parent1
        no `Father.parent2
        // narrator is married to the older woman
        `Narrator.spouse = `OlderWoman
        // older woman is the parent of the step daughter
        `StepDaughter.parent2 = `OlderWoman
        no `StepDaughter.parent1
        // narrator's father is the father
        `Narrator.parent1 = `Father 
        no `Narrator.parent2
        // father is married to the step daughter
        `Father.spouse = `StepDaughter
    } 


    example notOwnGrandparentExample is {not ownGrandparent} for {
        Person = `Narrator + `OlderWoman + `StepDaughter + `Father
        no `OlderWoman.parent1
        no `OlderWoman.parent2
        no `Father.parent1
        no `Father.parent2

        // narrator is married to the older woman
        `Narrator.spouse = `OlderWoman
        // older woman is the parent of the step daughter
        `StepDaughter.parent1 = `OlderWoman
        no `StepDaughter.parent2
        // narrator's father is the father
        `Narrator.parent1 = `Father 
        no `Narrator.parent2
        // father is not married to the step daughter
        no `Father.spouse
        no `StepDaughter.spouse
    }
}