/*

  Calculates the heal rate of a given source with the Flamethrower's healing debuff applied.
  The left portion is the healing added to the fraction in the frame, and the right is the fraction after the debuff is applied.

  Replace the DEBUFF_JI constant at line 40 with DEBUFF_OLD to see what it would've been before the debuff was nerfed from 25% to 20%.

*/

#include <iostream>

const int TICK_PER_SECOND = 66;

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
