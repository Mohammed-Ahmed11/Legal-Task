// src/utils.ts
import crypto from 'crypto';
import fs from 'fs/promises';

export async function fileHash(path: string) {
  const buf = await fs.readFile(path);
  return crypto.createHash('sha256').update(buf).digest('hex');
}

export function detectTypeFromText(text: string): 'legislation'|'judgment'|'fatwa'|null {
  const t = text.slice(0, 2000);
  if (/قانون|نظام|قرار|مادة|تشريع|لائحة/i.test(t)) return 'legislation';
  if (/محكمة|قضية|حكم|الاستئناف|الهيئة/i.test(t)) return 'judgment';
  if (/فتوى|إفتاء|الجواب|السؤال/i.test(t)) return 'fatwa';
  return null;
}

export function extractTitleFromHtml(html: string) {
  const h1 = html.match(/<h1[^>]*>([^<]+)<\/h1>/i);
  if (h1) return h1[1].trim();
  const h2 = html.match(/<h2[^>]*>([^<]+)<\/h2>/i);
  if (h2) return h2[1].trim();
  const text = html.replace(/<[^>]+>/g, '\n').replace(/\n+/g, '\n');
  const lines = text.split('\n').map(s=>s.trim()).filter(Boolean);
  return lines[0] || null;
}

export function extractDateFromText(text: string): string | null {
  const iso = text.match(/(\d{4})[-\/](\d{1,2})[-\/](\d{1,2})/);
  if (iso) return `${iso[1]}-${iso[2].padStart(2,'0')}-${iso[3].padStart(2,'0')}`;
  const dm = text.match(/(\d{1,2})[\/](\d{1,2})[\/](\d{4})/);
  if (dm) return `${dm[3]}-${dm[2].padStart(2,'0')}-${dm[1].padStart(2,'0')}`;
  return null;
}
