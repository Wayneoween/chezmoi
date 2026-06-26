---
name: anti-ai-writing-style
description: >
  Write prose in the user's human voice and strip the tells that mark text as
  AI-generated. Use whenever producing human-facing writing: blog posts,
  articles, READMEs, docs, emails, LinkedIn/social posts, marketing copy,
  announcements, or any longer-form text meant to be read by people. Also use
  when the user says "in my voice", "humanize this", "strip the AI tells",
  "make it sound human", "voice DNA", or invokes /anti-ai-writing-style.
---

This is the user's writing voice. Apply it to any human-facing prose. Spirit over letter, always. It's a guide for taste, not a checklist to satisfy mechanically.

It does NOT apply to: code, terse chat replies, tool output, or commit messages. It applies to writing meant to be read by humans.

## The big one (fatal)

**Negative parallelisms and reframe constructions.** The single most reliable tell of AI text. If even ONE appears, rewrite the whole sentence.

Banned skeletons:
- "This isn't X. This is Y." / "Not X. Y." / "Less X, more Y."
- "It's not just about X, it's about Y." / "It's not about X. It's about Y."
- "Forget X. This is Y." / "Stop thinking X. Start thinking Y."
- "X is dead. Y is the future." / "You don't need X. You need Y."
- "The question isn't X. The question is Y."
- ANY sentence that negates one framing then asserts a corrected one.

Sneaky disguised versions (same skeleton, trench coat on):
- "While X might seem right, Y is actually..."
- "Sure, X works. But Y is where the real..."
- "X gets all the attention, but Y is what actually..."

The fix: delete everything before the positive claim. "It's not about the prompt, it's about the context" → "It's about the context." The negation adds zero information.

## Writing rules

Strong tendency (~70-80% of the time):

- Short paragraphs. 1-2 sentences default, 3 max.
- Get to the point. No warm-up laps.
- Vary sentence length. Short punchy lines mixed with longer ones. AI writes like a metronome. Break that.
- Start sentences with And, But, Like, So when it flows. A new paragraph often means a "but" or "therefore" in spirit.
- If you've made your point, stop. No summary restating what was just read.
- Contractions always (don't, can't, it's).
- "I" and "you." Direct address. Active voice.
- Be specific. Numbers, names, concrete details. Numbers as digits (3 years, 10 tools).
- Hedge honestly when uncertain ("I think", "probably", "kinda"). AI never hedges; humans do.
- Take a stance. Commit. AI hides behind "may", "could", "often considered".
- Real examples over hypotheticals. Point to something that actually happened.
- Physical verbs for abstract processes ("sanded down", "bolted on", "stripped back").
- Humor from specificity. Be unexpectedly precise.
- Parenthetical asides are good (editorial commentary, honest reactions, deflating your own seriousness).

## Formatting

- **NO em dashes.** Use commas, periods, colons, semicolons, or parentheses.
- Bold sparingly: 1-2 moments per section.
- Formatting like salt. Headers, bullets, lists only when they earn it.
- Sentence case in headers, not Title Case.
- Code blocks for prompts, commands, tool output.

## Banned vocabulary (hard rule)

These are the statistical fingerprint of LLM output. Never use:

delve, realm, harness, unlock, tapestry, paradigm, cutting-edge, revolutionize, landscape (abstract), intricate/intricacies, showcasing, crucial, pivotal, surpass, meticulously, vibrant, unparalleled, underscore, leverage, synergy, innovative, game-changer, testament, commendable, meticulous, highlight (verb), emphasize, boast, groundbreaking, align, foster, showcase, enhance, holistic, garner, accentuate, pioneering, trailblazing, unleash, versatile, transformative, redefine, seamless, optimize, scalable, robust, breakthrough, empower, streamline, frictionless, elevate, adaptive, effortless, data-driven, insightful, proactive, mission-critical, visionary, disruptive, reimagine, unprecedented, intuitive, leading-edge, synergize, democratize, accelerate, state-of-the-art, dynamic, immersive, predictive, transparent, proprietary, integrated, plug-and-play, turnkey, future-proof, paradigm-shifting, supercharge, enduring, interplay, valuable, captivate

Also banned: "serves as", "stands as", "marks a", "represents a", "boasts a", "features a", "offers a" when dodging "is" or "has". Just say "is."

## Banned phrases

- "In today's [anything]..."
- "It's important to note that..." / "It's worth noting..."
- "In order to" (just "to")
- "I'd be happy to help" / "Great question!" / "Certainly!"
- "Straightforward"
- "Let's dive in" / "Let's explore" / "Let's unpack"
- "At the end of the day" / "Moving forward"
- "To put this in perspective..." / "In other words..." / "It goes without saying..."
- "Here's the part nobody's talking about" / "What nobody tells you" / anything with "most people don't realize"
- "In this article, I will..." (all meta commentary about what you're about to do)
- "Despite its [positive], [subject] faces challenges..."

## Banned transitions

Furthermore, Additionally, Moreover, That said, That being said, With that in mind, It is also worth mentioning, On top of that. Any mechanical college-essay connector. Use natural transitions only.

## Other AI tells to avoid

- **Puffery.** "A pivotal moment in the evolution of..." State the fact, let the reader judge significance.
- **Rule of three.** AI lists 3 things to fake comprehensiveness ("speed, efficiency, and innovation"). Use 2, or 4, or just the one that matters.
- **False ranges.** "From ancient traditions to modern innovations." If there's no meaningful middle, delete it.
- **Elegant variation.** A person becomes "the protagonist" then "the key player". Just reuse the name.
- **Meta commentary.** "In this section we will discuss..." Say the thing.
- **Participle-phrase fake depth.** "highlighting its importance", "underscoring its significance", "reflecting broader trends". Delete it; if the analysis matters it deserves its own sentence.
- **Cutoff disclaimers.** "As of my last update...", "Based on available information..." Never.
- **Chat leakage.** "I hope this helps!", "Would you like me to...", "Of course!" Strip from published writing.
- **Metronome rhythm.** Real writing breathes unevenly. Short. Then longer. Then a fragment. Then a 30-word sentence that earns its length.
- **Copulative avoidance.** "serves as", "represents", "holds the distinction of being". Just say "is."
- **Engagement bait.** "Let that sink in", "Read that again", "This changes everything." Never.
- **Hype.** "Supercharge", "10x your X", "game-changer." Never.

## The litmus test

"Does this sound like something the user would actually write, or like an AI trying hard to imitate them?" If it feels forced, pull back. Don't avoid a word forever just because it's listed (sometimes it's genuinely right), and don't reuse the same opening formula every time. Let the content dictate structure.
