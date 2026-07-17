import Foundation

/// The canned "giant mosquito" reading from `design/prototype.jsx`, used for
/// the offline demo path (FR-011) and as the decoding-test fixture (TASK-005).
enum SampleDream {
    static let title = "The giant mosquito at the park gate"

    static let text =
        "I was traveling with friends to a park in Japan. There was a rumor that Japanese mosquitoes were huge. I stayed outside the park while others entered. Suddenly everyone ran back out saying the mosquitoes really were huge, and then a giant black mosquito larger than a football flew out of the park."

    static let symbols = ["Insect", "Threshold", "Travel"]

    static let reading = ReadingDTO(
        summary: "A small, nagging worry has grown larger in your mind than in reality — and your instinct to pause before rushing in is quietly protecting you.",
        confidence: 78,
        tones: ["Anticipation", "Anxiety", "Relief", "Awe"],
        synthesis: "Every lens converges on one shape: something genuinely minor — an irritation, a doubt, a draining obligation — has been fed by rumor, expectation, and group emotion until it looks monstrous. The neuroscience view explains how (expectation renders what it predicts, larger); Zhougong and the spiritual view name what (a small trouble left unattended); Freud and Jung locate where you stand (at a threshold, choosing between belonging and self-protection). Notably, the dream never harms you. You paused, you observed, and the exaggerated fear revealed itself. The synthesis is not 'you are in danger' — it is 'look directly at the small thing before it grows again.'",
        mainMessage: "Name the mosquito. Somewhere in waking life there is a small, buzzing concern you have been managing by keeping your distance. The dream suggests distance has stopped working — the worry now arrives on its own.",
        concerns: [
            "A minor obligation or friction (work, social, or health) that you have postponed examining directly.",
            "Sensitivity to group opinion — the rumor moved through friends before anything was seen.",
            "A quiet fear of being 'drained' by something or someone if you commit fully.",
        ],
        opportunities: [
            OpportunityItem(kind: .opportunity, text: "Your pause at the gate was discernment, not cowardice — trust it in one real decision this week."),
            OpportunityItem(kind: .opportunity, text: "Exaggerated fears, once seen clearly, tend to shrink fast. The hard part is the looking."),
            OpportunityItem(kind: .warning, text: "Avoidance is rewarding in the short term; the dream hints the worry will keep growing if only observed from outside."),
            OpportunityItem(kind: .warning, text: "Borrowed anxiety: check whether this fear is originally yours, or absorbed from people around you."),
        ],
        questions: [
            "What is the smallest real-life version of the mosquito — the thing that buzzes at me most evenings?",
            "Whose voice first told me it was 'huge'? Have I verified that myself?",
            "Where am I currently waiting outside a gate while others go in — and is waiting still serving me?",
            "If the fear were exactly football-sized and no larger, what would I do tomorrow?",
        ],
        actions: [
            "Write down the one recurring worry that best matches the mosquito, in a single honest sentence.",
            "Spend 15 focused minutes gathering first-hand facts about it — replace the rumor with observation.",
            "Tell one of the 'friends' from the dream (or a real confidant) what the worry actually is.",
            "Before sleep tonight, revisit the gate in imagination and watch the mosquito calmly, without running.",
        ],
        balanceScore: 74,
        lenses: [
            LensReadingDTO(
                lens: .zhougong,
                short: "Mosquitoes are 'small troubles' — yours has been fed by worry.",
                full: "In the Zhougong tradition, mosquitoes represent minor nuisances or draining people (小人) circling your life. A mosquito grown monstrous suggests a small concern that has been allowed to swell far beyond its true size. Remaining outside the gate is read favorably: prudence at a threshold protects you from a trouble others rush into.",
                contributed: "Anchored the idea that the threat began small — the dream is about growth of worry, not the worry itself.",
                weight: 14
            ),
            LensReadingDTO(
                lens: .freud,
                short: "An anticipatory anxiety, inflated by the group, then confirmed.",
                full: "The rumor of huge mosquitoes is anticipatory anxiety: a fear rehearsed before any encounter. The insect condenses a vaguer worry about being intruded upon or 'drained.' Waiting outside is a classic avoidance compromise — you satisfy the wish to belong (you traveled with friends) while defending against the feared contact. The dream then vindicates the avoidance: the threat is real, and enormous.",
                contributed: "Identified avoidance-with-belonging as the central tension, and the rumor as rehearsed fear.",
                weight: 18
            ),
            LensReadingDTO(
                lens: .jung,
                short: "A small shadow-fear given monstrous, almost mythic form.",
                full: "The park gate is a threshold archetype — a boundary between the known self and unexplored territory. Friends cross; the dreamer waits. The giant black mosquito is a shadow figure: an ordinary irritation the psyche has mythologized so it can finally be seen. That it flies out to meet you suggests the confrontation cannot be outsourced to the group — the exaggerated fear seeks you specifically, asking to be examined rather than fled.",
                contributed: "Framed the mosquito as your own exaggerated fear personified, and the gate as a decision point.",
                weight: 24
            ),
            LensReadingDTO(
                lens: .neuro,
                short: "REM threat-simulation, primed by expectation and social contagion.",
                full: "This fits threat-simulation theory: during REM sleep the amygdala rehearses danger in exaggerated form, at low cost. Predictive-processing research adds a neat detail — the 'rumor' primes the perception, so the brain renders exactly what was expected, only larger. Fear spreading through the group of friends mirrors social threat contagion, which the sleeping brain readily amplifies.",
                contributed: "Explained the mechanism: expectation shaped the imagery, and the exaggeration is rehearsal, not prophecy.",
                weight: 20
            ),
            LensReadingDTO(
                lens: .culture,
                short: "Travel novelty plus folklore-scale exaggeration of the unfamiliar.",
                full: "Dreams set abroad often process novelty stress — the low hum of navigating an unfamiliar place. Japanese folklore is rich with ordinary creatures grown uncanny (yōkai), and the football-sized mosquito borrows that grammar: the foreign is rendered as the familiar, magnified. A park — curated nature — hiding something wild inverts the promise of safety in the unfamiliar.",
                contributed: "Placed the imagery in a travel/novelty context, softening the personal-threat reading.",
                weight: 12
            ),
            LensReadingDTO(
                lens: .spirit,
                short: "A messenger insisting a small irritation carries a lesson.",
                full: "In many contemplative traditions the mosquito is a persistent messenger: a small thing that will keep returning, and growing, until it receives attention. Honoring your instinct to pause at the threshold is read as intuition working correctly. The dream does not punish the pause — it rewards it with clarity about what everyone else ran from.",
                contributed: "Reframed the pause at the gate as wisdom rather than fear, and the mosquito as a signal worth heeding.",
                weight: 12
            ),
        ]
    )
}
