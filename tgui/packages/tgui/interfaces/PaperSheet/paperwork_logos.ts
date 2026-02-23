// Paperwork logo tag replacement utility for TGUI

const logoMap: Record<string, { src: string; alt: string }> = {
  ntlogo: {
    src: '/images/logos/paradise/ntlogo.png',
    alt: 'NT Logo',
  },
  syndielogo: {
    src: '/images/logos/paradise/syndielogo.png',
    alt: 'Syndicate Logo',
  },
  ntlogoalt: {
    src: '/images/logos/baystation/bluentlogo.png',
    alt: 'NT Logo Alt',
  },
  sollogo: {
    src: '/images/logos/paradise/sollogo.png',
    alt: 'SolFed Logo',
  },
  sollogoalt: {
    src: '/images/logos/baystation/sollogo.png',
    alt: 'SolFed Logo Alt',
  },
};

export function replacePaperworkLogos(html: string): string {
  let result = html;
  for (const [tag, { src, alt }] of Object.entries(logoMap)) {
    const regex = new RegExp(`\\[${tag}\\]`, 'gi');
    result = result.replace(
      regex,
      `<img src='${src}' alt='${alt}' style='height: 32px; vertical-align: middle;' />`,
    );
  }
  return result;
}
