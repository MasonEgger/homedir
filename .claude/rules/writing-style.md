---
paths:
  - "**/*.md"
  - "**/*.mdx"
  - "**/*.markdown"
  - "**/*.txt"
  - "**/*.rst"
  - "**/*.html"
  - "**/*.adoc"
  - "**/*.qmd"
  - "**/slides/**"
  - "**/slidev/**"
  - "**/blog/**"
  - "**/posts/**"
  - "**/drafts/**"
  - "**/docs/**"
  - "**/content/**"
  - "**/notes/**"
  - "**/zk/**"
  - "**/journal/**"
  - "**/wiki/**"
  - "**/README*"
  - "**/CHANGELOG*"
  - "**/CONTRIBUTING*"
---

# Writing style: avoid AI tells

Adapted from [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing).
These rules apply to any prose I publish, share, or that bears my name. The global
hard rules (em-dashes, top banned phrases) live in `~/.claude/CLAUDE.md`. This file
is the full taxonomy with examples and human alternatives.

Rule of thumb: if a sentence reads like a press release, a marketing one-pager, or
a LinkedIn post, rewrite it.

## 1. Banned Vocabulary

Statistically overused by LLMs. Avoid even when a single instance feels fine; the
sum total of these words is the tell.

### Current-era tells (mid-2025 onward, still strongly correlated)

`align with`, `comprehensive`, `delve`, `delving`, `dive in`, `dive into`, `emphasize`,
`emphasizing`, `enhance`, `fostering`, `highlight`, `highlighting`, `holistic`,
`leverage`, `realm`, `robust`, `seamless`, `seamlessly`, `showcase`, `showcasing`,
`streamline`, `tapestry`, `transformative`, `unleash`, `unlock`, `vibrant`.

### Earlier-era tells (still common in mid-tier models)

`additionally` (sentence-initial), `boasts` (meaning "has"), `bolstered`, `crucial`,
`enduring`, `garner`, `intricate`, `intricacies`, `interplay`, `key` (as filler
adjective), `landscape` (abstract noun), `meticulous`, `meticulously`, `pivotal`,
`testament`, `underscore` (verb), `valuable` (as filler adjective).

### Human alternatives

Most of these can just be deleted. When a replacement is needed:

| Tell                  | Human form                                |
|-----------------------|-------------------------------------------|
| `delve into`          | `cover`, `examine`, or just delete        |
| `comprehensive`       | `complete`, `full`, or delete             |
| `leverage`            | `use`                                     |
| `robust`              | `stable`, `tested`, `reliable`            |
| `seamless`            | delete, or describe what specifically works |
| `tapestry`            | delete (almost never literal)             |
| `crucial`             | `important`, or delete                    |
| `landscape` (abstract)| name the actual thing                     |
| `pivotal`             | `important`, or delete                    |
| `boasts` (= has)      | `has`                                     |

## 2. Syntax Tells

### Em-dashes and en-dashes

No em-dashes (—) or en-dashes (–) anywhere. Hyphens (-) are fine for compound words
and ranges. Substitute with periods, commas, parentheses, colons, or semicolons.

### "Not just X, it's Y" / "Not only X, but Y" parallelism

The most over-used LLM construction. Drop it. State what the thing is.

- Bad: "It's not just a CLI, it's a way of thinking about your workflow."
- Bad: "Not only does it parse the file, but it also validates the schema."
- Good: "It validates the schema as it parses."

### "Not X, but Y" corrective parallelism

Same family, same fix.

- Bad: "It's not a mirror, but a portal."
- Good: just say what it is.

### Rule of three

Three-part lists ("fast, reliable, scalable") used for rhetorical rhythm. Use one
strong adjective or rewrite as a clause. Lists of three are fine when the three
items are *specific and different*; avoid them when they're synonymous filler.

### Copula replacement

LLMs avoid plain `is`/`are`. They reach for `serves as`, `represents`, `marks`,
`features`, `stands as`. Use plain copulas.

- Bad: "The library serves as a wrapper around requests."
- Good: "The library wraps requests."

### Elegant variation (synonym churn)

Repeating the same noun is fine. LLMs swap synonyms to dodge repetition penalties,
which reads stilted. If you're talking about "the parser", call it "the parser"
every time, not "the engine", "the component", "the utility".

## 3. Structure and Formatting Tells

### Title Case in headings

Use Title Case for headings. Capitalize the principal words: the first and
last word, and every noun, pronoun, verb, adjective, and adverb. Lowercase
short articles, conjunctions, and prepositions (a, an, the, and, or, but,
of, to, in, on) unless they start the heading.

This is a deliberate personal preference. The Wikipedia source this file is
adapted from flags Title Case as an AI tell and prefers sentence case; I do
not. Title Case is my style.

- Good: `## Building a Scalable Notification System`
- Avoid: `## Building a scalable notification system`

### Bold-emphasis overuse

Bold is for the *first* introduction of a defined term, or for an actual UI label.
Not for "key takeaways", not for every noun you want the reader to notice.

- Bad: "The **parser** reads the **input** and produces an **AST**."
- Good: "The parser reads the input and produces an AST."

### Bullet+colon canned format

The dead giveaway formatting pattern:

```
- **Historical Context**: The world was rapidly changing...
- **Implementation Details**: The system uses a queue...
- **Future Outlook**: The team plans to...
```

When every bullet starts with **Bold Header**: then prose, it reads like ChatGPT.
Either write prose paragraphs or use plain bullets. Bold inline headers in lists
are fine *sparingly* for genuine reference material; not as a default pattern.

### Smart quotes / curly apostrophes

Use straight quotes (`"` and `'`) in source files. LLMs leak `"`, `"`, `'`, `'`
because they're trained on rendered prose. In markdown source, code, configs,
commit messages, and any file that won't go through a typesetting pass: straight only.

### Unnecessary tables

Don't tablify content that should be prose or a list. Two-column tables of
"Aspect | Description" are a tell.

### Thematic breaks before headings

Don't insert `---` horizontal rules before every heading. Headings separate
themselves.

### Skipping heading levels

Sequential only. No `###` under an `h1` with no `##` between them.

## 4. Tone Tells

### Promotional / press-release voice

The single biggest tell. If a sentence sounds like marketing copy, rewrite it.

- Bad: "Nestled within the breathtaking region, the application offers a seamless experience."
- Bad: "This pivotal release marks a transformative moment in the project's evolution."
- Good: "The 0.8 release adds Reclaim integration."

### Significance / legacy puffery

Don't editorialize about why something matters. Show, don't tell.

- Bad: "This represents a pivotal moment in the evolution of regional statistics."
- Good: state the fact; let the reader decide if it's pivotal.

### Cultural / heritage padding

"Rich cultural heritage", "vibrant community", "deep traditions" applied to any
subject. Cut entirely or replace with one specific concrete detail.

### Vague attribution / weasel words

"Researchers say", "industry observers note", "many experts believe", "reports
indicate". Either name a specific source or drop the claim.

- Bad: "Many developers prefer this approach."
- Good: "DHH described this approach in [his 2024 keynote]." (or skip the claim)

### "Despite challenges, the future is bright" template

The formulaic conclusion. Detect by structure: positive setup → "however" or
"despite" → vague optimism. Cut the optimism or replace with a concrete statement
about what happens next.

- Bad: "Despite ongoing challenges, the project continues to thrive and looks
  forward to a promising future."
- Good: state what the next milestone is and when.

### Knowledge-cutoff disclaimers and source speculation

Don't write "As of my last update..." or "There may be more recent developments..."
Just state what you know. If unsure, omit.

### Defensive feedback-seeking

"I welcome constructive criticism", "happy to refine based on your input",
"please let me know if anything needs adjustment". Cut. State what you wrote and
move on.

### "Let's explore / dive into / take a closer look at"

Preambles announcing what's about to happen. Just do the thing.

### "In conclusion" / "To summarize" / "All things considered"

Sign-offs. The reader can see the end of the document. Trust them.

## 5. Meta Patterns

These are the *why* behind most tells above. Recognizing them helps catch new ones.

### Regression to the mean

LLMs default to statistically common phrasings. The specific, unusual, or
idiomatic version is the human one. When you have a choice between the generic
and the specific, go specific.

### Repetition penalty as elegant variation

Models are trained to avoid repeating words. Humans repeat words. If you find
yourself searching for a synonym for the third "parser" in a paragraph, stop;
just write "parser" again.

### Formulaic structure dependence

LLMs reach for templates: intro → context → "key points" → "challenges" →
"future". Vary your structure. Sometimes lead with the conclusion. Sometimes
skip context entirely. Sometimes end mid-thought because that's where the thought
ends.

### Abrupt style shifts

If part of a document sounds like one person and part sounds like a different
person, that's the AI seam. Smooth over by rewriting *both* parts in your voice,
not just splitting the difference.

## 6. The Quick Self-Check

Before publishing any prose, scan for:

1. Em-dashes (`—`) or en-dashes (`–`): any present? Replace.
2. Bullet+colon pattern repeating more than twice? Rewrite as prose.
3. The word `delve`, `tapestry`, `vibrant`, `seamless`, `comprehensive`, `robust`,
   `leverage`, `crucial`, `pivotal`, `landscape`, or `realm`? Examine each.
4. "Not just X, it's Y" anywhere? Rewrite.
5. Bold on more than ~3 things per paragraph? Strip most.
6. Sentence that sounds like marketing? Rewrite plainly.
7. "Despite challenges, the future..."? Cut.
8. Three-adjective adjective stack (`fast, reliable, scalable`)? Pick one or rewrite.

If any of these fire, the prose has AI scent. Fix and re-scan.

## 7. What Human Writing Looks Like

The contrast. When in doubt, write more like this:

- Short sentences mixed with long ones.
- Specific names, specific numbers, specific dates.
- Direct claims with stated sources or no source at all.
- Repeated words where repetition is natural.
- Plain copulas (`is`, `are`, `was`).
- Occasional incomplete sentences. Like this.
- Occasional sentence fragments for emphasis.
- Mid-thought corrections ("actually, scratch that").
- Personal preference stated as preference, not as universal fact.

Voice over polish. Polish is where the AI lives.
