# Public skills

Skills installed with `npx skills` from public repos. `npx skills` owns them,
so chezmoi doesn't track their files. Run these once on a new machine.

```sh
npx skills add tt-a1i/archify -g -s archify -s archify-review
npx skills add DietrichGebert/ponytail -g -s ponytail -s ponytail-audit -s ponytail-debt -s ponytail-review
npx skills add conorbronsdon/avoid-ai-writing -g -s avoid-ai-writing
npx skills add luchasarie/bro-skill -g -s bro
npx skills add antonbabenko/terraform-skill -g -s terraform-skill
```

Update them all with `npx skills update -g`.
