#lang forge/bsl

open "physical_keys.frg"
//// Do not edit anything above this line ////

------------------------------------------------------------------------

// Remember that this assignment has Toadus Ponens support!
// Check out https://docs.google.com/document/d/1zdv6uF7jdC8CR-d73AojsH68jaLmNG3MwlcZ9R2lWpc/edit?usp=sharing for more information.

test suite for wellformed {
    test expect { wellFormedLock: {
        some l: Lock | 
            l.breaks[0][0] = True and 
            l.breaks[1][1] = True and
            wellformed} is sat 
    }

    -- a lock with a negative tumbler index
    test expect { negativeTumblerIndex: {
        some l: Lock | 
            l.breaks[-1][0] = True and 
            wellformed} is unsat 
    }

    -- a lock with negative break length
    test expect { negativeBreakLength: {
        some l: Lock | 
            l.breaks[0][-1] = True and 
            wellformed} is unsat 
    }

    -- a lock with no breaks
    test expect { lockWithNoBreaks: {
        some l: Lock | 
            no t: Int, b: Int | l.breaks[t][b] = True and 
            wellformed} is sat 
    }

    -- a lock with a break at index 0
    test expect { breakAtIndexZero: {
        some l: Lock | 
            l.breaks[0][0] = True and 
            wellformed} is sat 
    }
}


test suite for manufacturer_standard {

    test expect { standardLock: {
        some l: Lock | 
            all t: Int | (t >= 0 and t <= 4) implies (#{b : Int | l.breaks[t][b] = True} = 2)
            manufacturer_standard} is sat }

    -- a lock having breaks outside range
    test expect { breaksOutsideRange: {
        some l: Lock | 
            l.breaks[2][0] = True or l.breaks[2][6] = True and 
            manufacturer_standard} is unsat }

  -- a lock having too many breaks in a tumbler
    test expect { tooManyBreaksInTumbler: {
        some l: Lock | 
            l.breaks[1][2] = True and l.breaks[1][3] = True and l.breaks[1][4] = True and 
            manufacturer_standard} is unsat }

  -- a lock having no breaks in a tumbler
    test expect { noBreaksInTumbler: {
        some l: Lock | 
            no b: Int | l.breaks[0][b] = True and 
            manufacturer_standard} is unsat }
}


test suite for lockOpenedWith {

    -- a matching key
    test expect { matchingKey: {
        some l: Lock, cut0, cut1, cut2, cut3, cut4: Int | 
            l.breaks[0][cut0] = True and l.breaks[1][cut1] = True and 
            l.breaks[2][cut2] = True and l.breaks[3][cut3] = True and 
            l.breaks[4][cut4] = True and
            lockOpenedWith[l, cut0, cut1, cut2, cut3, cut4]} is sat }

    -- a non-matching key
    test expect { nonMatchingKey: {
        some l: Lock, cut0, cut1, cut2, cut3, cut4: Int | 
            l.breaks[0][cut0+1] = True and l.breaks[1][cut1] = True and 
            l.breaks[2][cut2] = True and l.breaks[3][cut3] = True and 
            l.breaks[4][cut4] = True and
            not lockOpenedWith[l, cut0, cut1, cut2, cut3, cut4]} is sat }
}

test suite for noOtherLockOpenedWith {

  -- unique key and lock pair
    test expect { uniqueKeyLockPair: {
        some l: Lock, cut0, cut1, cut2, cut3, cut4: Int |
        some otherLocks: Lock | otherLocks != l and
            l.breaks[0][cut0] = True and l.breaks[1][cut1] = True and
            l.breaks[2][cut2] = True and l.breaks[3][cut3] = True and
            l.breaks[4][cut4] = True and
            noOtherLockOpenedWith[l, cut0, cut1, cut2, cut3, cut4]} is sat }

    -- multiple locks and a unique key
    test expect { multipleLocksUniqueKey: {
        some l, otherLock1, otherLock2: Lock | l != otherLock1 and l != otherLock2 and
            l.breaks[0][2] = True and l.breaks[1][3] = True and
            l.breaks[2][4] = True and l.breaks[3][2] = True and
            l.breaks[4][3] = True and
            otherLock1.breaks[0][1] = True and otherLock2.breaks[4][4] = True and
            noOtherLockOpenedWith[l, 2, 3, 4, 2, 3]} is sat }
}

test suite for known {
    
    -- lock with its unique key
    test expect { uniqueKeyForLockA: {
        some disj aLockA, aLockB, aLockC, aLockD, aLockE: Lock |
        known and
        lockOpenedWith[aLockA, 1, 2, 3, 4, 5]} is sat }

    test expect { uniqueKeyForLockB: {
        some disj aLockA, aLockB, aLockC, aLockD, aLockE: Lock |
        known and
        lockOpenedWith[aLockB, 5, 4, 3, 2, 1]} is sat }

    -- case for aLockA and aLockE
    test expect { specialCaseKey: {
        some disj aLockA, aLockB, aLockC, aLockD, aLockE: Lock |
        known and
        lockOpenedWith[aLockA, 3, 4, 5, 2, 1] and
        lockOpenedWith[aLockE, 3, 4, 5, 2, 1]} is sat }

    -- incorrect key combinations
    test expect { incorrectKeyForLockA: {
        some disj aLockA, aLockB, aLockC, aLockD, aLockE: Lock |
        known and
        not lockOpenedWith[aLockA, 5, 4, 3, 2, 1]} is sat }
}


test suite for solutionOpensAllLocks {

    -- key that opens all locks
    test expect { keyOpensAllLocks: {
        some key: Key | 
        all l: Lock | lockOpenedWith[l, key.cut0, key.cut1, key.cut2, key.cut3, key.cut4] and
            solutionOpensAllLocks} is sat }

    -- key that does not open all locks
    test expect { keyDoesNotOpenAllLocks: {
        some key: Key, l: Lock | 
            not lockOpenedWith[l, key.cut0, key.cut1, key.cut2, key.cut3, key.cut4] and
            not solutionOpensAllLocks} is sat }

    -- no keys
    test expect { noKeys: {
        no key: Key | solutionOpensAllLocks} is unsat }
}


test suite for lock_tolerances {
    test expect { locksFollowTolerance: {
        some l: Lock | 
            l.breaks[0][1] = True and l.breaks[0][2] = False and
            l.breaks[1][3] = True and l.breaks[1][4] = False and
            lock_tolerances} is sat }

    test expect { locksViolatingTolerance: {
        some l: Lock | 
            l.breaks[0][1] = True and l.breaks[0][2] = True and
            not lock_tolerances} is sat }
}
