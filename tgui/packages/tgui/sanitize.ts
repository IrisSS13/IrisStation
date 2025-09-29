/**
 * Uses DOMPurify to purify/sanitise HTML.
 */

import DOMPurify from 'dompurify';

// Default values
const defTag = [
  'b',
  'blockquote',
  'br',
  'center',
  'code',
  'dd',
  'del',
  'div',
  'dl',
  'dt',
  'em',
  'font',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'hr',
  'i',
  'ins',
  'li',
  'menu',
  'ol',
  'p',
  'pre',
  'span',
  'strong',
  'table',
  'tbody',
  'td',
  'th',
  'thead',
  'tfoot',
  'tr',
  'u',
  'ul',
  // Additional tags for creative paper formatting
  'small',
  'big',
  'sub',
  'sup',
  'strike',
  's',
  'tt',
  'var',
  'kbd',
  'samp',
  'cite',
  'dfn',
  'abbr',
  'acronym',
  'address',
  'bdo',
  'q',
  'mark',
  'ruby',
  'rt',
  'rp',
];

// Advanced HTML tags that we can trust admins (but not players) with
const advTag = ['img'];

// Allowed HTML attributes for paper formatting
const allowedAttr = [
  'class',
  'style',
  'color',
  'align',
  'valign',
  'width',
  'height',
  'border',
  'cellpadding',
  'cellspacing',
  'colspan',
  'rowspan',
  'size',
  'face',
  'dir',
  'lang',
  'title',
  'id',
];

// Forbidden attributes that could be security risks
const forbiddenAttr = [
  'background', // Can contain image URLs - security risk
  'src',
  'href',
  'onclick',
  'onload',
  'onerror',
  'onmouseover',
  'onmouseout',
  'onfocus',
  'onblur',
  'onchange',
  'onsubmit',
  'action',
  'method',
  'target',
];

// Safe CSS properties that can be used in styling
const allowedCssProperties = [
  'color',
  'background-color',
  'background-image',
  'background-repeat',
  'background-position',
  'background-size',
  'font-size',
  'font-family',
  'font-weight',
  'font-style',
  'text-align',
  'text-decoration',
  'text-transform',
  'margin',
  'margin-top',
  'margin-bottom',
  'margin-left',
  'margin-right',
  'padding',
  'padding-top',
  'padding-bottom',
  'padding-left',
  'padding-right',
  'border',
  'border-width',
  'border-style',
  'border-color',
  'border-top',
  'border-bottom',
  'border-left',
  'border-right',
  'width',
  'height',
  'max-width',
  'max-height',
  'min-width',
  'min-height',
  'display',
  'float',
  'clear',
  'line-height',
  'letter-spacing',
  'word-spacing',
  'vertical-align',
  'white-space',
  'overflow',
  'text-indent',
];

// CSS values that should be blocked for security
const blockedCssValues = [
  'javascript:',
  'expression(',
  'behavior:',
  'moz-binding:',
  '@import',
  'url(',
];

/**
 * Validates CSS style attributes to prevent XSS attacks
 * @param styleValue - The CSS style string to validate
 * @returns Object with sanitized style and blocked properties summary
 */
function validateCssStyle(styleValue: string): {
  sanitized: string;
  blocked: string[];
} {
  if (!styleValue || typeof styleValue !== 'string') {
    return { sanitized: '', blocked: [] };
  }

  const blocked: string[] = [];
  const sanitizedRules: string[] = [];

  // Split CSS rules by semicolon
  const rules = styleValue.split(';');

  for (const rule of rules) {
    if (!rule.trim()) continue;

    const colonIndex = rule.indexOf(':');
    if (colonIndex === -1) continue;

    const property = rule.substring(0, colonIndex).trim().toLowerCase();
    const value = rule.substring(colonIndex + 1).trim();

    // Check if property is allowed
    if (!allowedCssProperties.includes(property)) {
      blocked.push(`${property}: ${value}`);
      continue;
    }

    // Check for dangerous values
    let isDangerous = false;

    // Special handling for background-image - allow gradients but block URLs
    if (property === 'background-image') {
      const lowerValue = value.toLowerCase();
      if (lowerValue.includes('url(') && !lowerValue.includes('data:')) {
        // Block external URLs but allow data URLs
        blocked.push(`${property}: ${value} (external URL not allowed)`);
        isDangerous = true;
      } else if (
        lowerValue.includes('javascript:') ||
        lowerValue.includes('expression(')
      ) {
        // Block dangerous functions
        blocked.push(`${property}: ${value} (dangerous function)`);
        isDangerous = true;
      }
      // Allow gradients (linear-gradient, radial-gradient, repeating-linear-gradient, etc.)
    } else {
      // Standard dangerous value check for other properties
      for (const dangerousValue of blockedCssValues) {
        if (value.toLowerCase().includes(dangerousValue)) {
          blocked.push(`${property}: ${value} (contains ${dangerousValue})`);
          isDangerous = true;
          break;
        }
      }
    }

    if (!isDangerous) {
      sanitizedRules.push(`${property}: ${value}`);
    }
  }

  return {
    sanitized: sanitizedRules.join('; '),
    blocked: blocked,
  };
}

/**
 * Feed it a string and it should spit out a sanitized version.
 * For paper content, returns an object with sanitized HTML and blocked content summary for logging.
 *
 * @param input - Input HTML string to sanitize
 * @param advHtml - Flag to enable/disable advanced HTML
 * @param tags - List of allowed HTML tags
 * @param allowAttr - List of allowed HTML attributes
 * @param advTags - List of advanced HTML tags allowed for trusted sources
 * @returns Sanitized HTML string or object with sanitized content and blocked summary
 */
export function sanitizeText(
  input: string,
  advHtml = false,
  tags = defTag,
  allowAttr = allowedAttr,
  advTags = advTag,
): string | { sanitized: string; blockedSummary?: string } {
  // This is VERY important to think first if you NEED
  // the tag you put in here.  We are pushing all this
  // though dangerouslySetInnerHTML and even though
  // the default DOMPurify kills javascript, it doesn't
  // kill href links or such
  if (advHtml) {
    tags = tags.concat(advTags);
  }

  let blockedCssItems: string[] = [];

  // Pre-process to validate CSS in style attributes
  let processedInput = input;
  if (input.includes('style=')) {
    // Find and validate all style attributes
    const styleRegex = /style\s*=\s*["']([^"']+)["']/gi;
    processedInput = input.replace(styleRegex, (match, styleValue) => {
      const validation = validateCssStyle(styleValue);
      if (validation.blocked.length > 0) {
        blockedCssItems = blockedCssItems.concat(validation.blocked);
      }
      return validation.sanitized ? `style="${validation.sanitized}"` : '';
    });
  }

  const sanitized = DOMPurify.sanitize(processedInput, {
    ALLOWED_TAGS: tags,
    ALLOWED_ATTR: allowAttr,
    FORBID_ATTR: forbiddenAttr,
  });

  // If we have blocked CSS items, return object for admin logging
  if (blockedCssItems.length > 0) {
    return {
      sanitized: sanitized,
      blockedSummary: `Blocked CSS: ${blockedCssItems.join(', ')}`,
    };
  }

  return sanitized;
}
