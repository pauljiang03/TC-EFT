// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://pauljiang03.github.io',
  base: '/TC-EFT',
  trailingSlash: 'always',
  devToolbar: { enabled: false },
  // Old links to /overview/ land on the root Overview page.
  redirects: { '/overview': '/TC-EFT/' },
  integrations: [
    starlight({
      title: 'TC-EFT',
      description:
        'A Lean 4 model of NVIDIA Tensor Core block arithmetic, its non-monotonicity, and the TC-EFT correction algorithm.',
      customCss: ['./src/styles/theme.css'],
      expressiveCode: {
        themes: ['github-dark-dimmed', 'github-light'],
        styleOverrides: { borderRadius: '2px', frames: { shadowColor: 'transparent' } },
      },
      social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/pauljiang03/TC-EFT' }],
      sidebar: [
        {
          label: 'Start here',
          items: [
            { label: 'Overview', link: '/' },
            { label: 'Quick start', slug: 'quick-start' },
            { label: 'Project status', slug: 'status' },
          ],
        },
        {
          label: 'Modeling the Tensor Core',
          items: [
            { label: 'The model at a glance', slug: 'model' },
            { label: '1. Formats and decoding', slug: 'model/formats' },
            { label: '2. Exact raw products', slug: 'model/products' },
            { label: '3. Alignment', slug: 'model/alignment' },
            { label: '4. Accumulation', slug: 'model/accumulation' },
            { label: '5. Output conversion', slug: 'model/conversion' },
            { label: '6. Architecture profiles', slug: 'model/profiles' },
            { label: '7. Instructions and chaining', slug: 'model/instructions' },
            { label: '8. Independent specification', slug: 'model/specification' },
            { label: '9. Hardware validation', slug: 'model/validation' },
            { label: 'Modeling scope and limits', slug: 'model/scope' },
          ],
        },
        {
          label: 'Properties & algorithms',
          items: [
            { label: 'Error bounds', slug: 'properties/error-bounds' },
            { label: 'Non-monotonicity', slug: 'properties/non-monotonicity' },
            { label: 'TC-EFT correction', slug: 'properties/eft' },
          ],
        },
        {
          label: 'Proofs & trust',
          items: [
            { label: 'Theorem index', slug: 'proofs/theorems' },
            { label: 'Trust boundary', slug: 'proofs/trust' },
            { label: 'FloatLib cross-check', slug: 'proofs/floatlib' },
          ],
        },
        {
          label: 'Reference',
          items: [
            { label: 'Commands', slug: 'reference/commands' },
            { label: 'Repository layout', slug: 'reference/layout' },
          ],
        },
      ],
    }),
  ],
});
