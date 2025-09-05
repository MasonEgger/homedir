## Requrired Checks
You MUST perform these checks and they must BOTH be true before you proceed

- Check to see if the directory you are working in is an Obsidian Vault. If it isn't, tell the user this command is only for use in an Obsidian Vault and do no more work.
- Calculate the year using `date +%Y` and save at {year}. Check to see if there is a Journal entry in @Journal/{year}/current/{$argument}.md. If there isn't, tell the user to create the journal entry for that day and do NO MORE WORK.

## Writing my Journal Entry
- My writing tone/voice is stored in @CLAUDE.md. Read this entire section and understand how I write and speak.
- Look for a @transcript.md file. This is a transcript of a voice recording for my daily journal entry. You will read this file and clean it up according to my voice. Make as FEW changes as possible while also making it coherent.
    - However, you should put things in chronological order. The transcript may say something like "Oh, before that we did this" and you should rewrite that part in my voice so the blog for the day flows organically.    - You can also make sub header 3s for different sections. The sections you can make are Personal, Work, and PyTexas.
- Write this clened up content to the #Blog section to {$argument}.md file you checked above.
    - You should add Obsidian cross links to things you think are relevant or pages I have already created.
    - When determining if a link is worth cross linking too, analyze the layout of my vault and see if that's the kind of thing I'd like to store. If so, create a cross link, even if the other file doesn't exist, and I'll fill it in later.
