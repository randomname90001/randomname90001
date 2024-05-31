/*

  Calculates the heal rate of a given source with the Flamethrower's healing debuff applied.
  The left portion is the healing added to the fraction in the frame, and the right is the fraction after the debuff is applied.

  Replace the DEBUFF_JI constant at line 64 with DEBUFF_OLD to see what it would've been before the debuff was nerfed from 25% to 20%.

*/

#include <iostream>

const int TICK_PER_SECOND = 66;

// Tick rate of shounic's 100 player server
const float TICK_HUNDRED_PLAYER = 10;

// Level 2 Dispenser
const float DISPENSER_HEAL_TICK = (15.0 / TICK_PER_SECOND);

// Level 3 Dispenser
const float DISPENSER_HEAL_TICK_MAX = (20.0 / TICK_PER_SECOND);

// Medic's Medigun at default ramp
const float MEDIGUN_HEAL_TICK = (24.0 / TICK_PER_SECOND);

// Medic's Medigun at max ramp
const float CRIT_HEAL_TICK = (72.0 / TICK_PER_SECOND);

// Quick-fix uber
const float UBERHEAL_TICK = ((33.6 * 3) / TICK_PER_SECOND);

// Theoretical minimum health per second to not remove healing completely (Meet Your Match)
const float TEST_HEAL_TICK = (17.6 / TICK_PER_SECOND);

// Same as above (Jungle Inferno)
const float TEST_HEAL_TICK_NEW = (16.5 / TICK_PER_SECOND);

// Meet Your Match to Jungle Inferno
const float DEBUFF_OLD = 0.75;
// Post-Jungle Inferno
const float DEBUFF_JI = 0.8;

using namespace std;

int main()
{
    float flHealFraction = 0.0;
    int iHealAmount = 0;
    int iTotalHealth = 0;

    float flHealRate;

    cout << "Heal rate of source: ";
    cin >> flHealRate;
    cout << '\n';

    flHealRate /= TICK_PER_SECOND;
    
    for (int i = 0; i < TICK_PER_SECOND; i++)
    {
        flHealFraction += flHealRate;
        cout << flHealFraction << "- > ";
        
        flHealFraction *= DEBUFF_JI;
        cout << flHealFraction << '\n';
        
        iHealAmount = (int)flHealFraction;
        
        if (iHealAmount > 0)
        {
            iTotalHealth += iHealAmount;
            flHealFraction -= iHealAmount;
        }
            
    }
    
    if (iTotalHealth > 0)
        cout << "Player received " << iTotalHealth << " health in 1 second.";
    else
        cout << "Player is unable to heal from this source.";

    return 0;
}
