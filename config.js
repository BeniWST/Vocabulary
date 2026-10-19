// ============================================================
//  Vokabeltrainer – Konfiguration
//  Nur diese Datei musst du anpassen.
//
//  supabaseUrl / supabaseKey LEER lassen = lokaler Testmodus
//  (alles bleibt nur auf dem jeweiligen Gerät gespeichert).
// ============================================================
window.VT_CONFIG = {
  // z. B. "https://abcdefghijklm.supabase.co"
  supabaseUrl: "",

  // "Publishable key" (sb_publishable_…) bzw. "anon public" Key.
  // Dieser Schlüssel darf öffentlich sein – geschützt wird über Login + Row Level Security.
  supabaseKey: "",

  // Sprachen: speech = Stimme für die Vorlesefunktion (null = kein Vorlesen)
  languages: {
    en: { name: "Englisch",    flag: "🇬🇧", speech: "en-GB" },
    fr: { name: "Französisch", flag: "🇫🇷", speech: "fr-FR" },
    la: { name: "Latein",      flag: "🏛️", speech: null }
  }
};
