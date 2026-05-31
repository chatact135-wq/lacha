"use client";
import { useEffect, useMemo, useState } from "react";

type Settings = Record<string, any>;
type Category = Record<string, any>;
type Item = Record<string, any>;

type Lang = "en" | "ar";

const BUILT_IN_SLIDES = [
  "/images/hero-slide-1.png",
  "/images/hero-slide-2.png",
  "/images/hero-slide-3.png",
  "/images/hero-slide-4.png",
  "/images/hero-slide-5.png",
];

function itemName(it: Item, lang: Lang) {
  return (lang === "ar" ? it.name_ar || it.name_en : it.name_en || it.name_ar) || "Menu item";
}

function itemDesc(it: Item, lang: Lang) {
  return (lang === "ar" ? it.description_ar || it.description_en : it.description_en || it.description_ar) || "Freshly prepared by La Cha Cha.";
}

function discountPercent(it: Item) {
  const value = Number(it.discount_percent || 0);
  return Number.isFinite(value) ? Math.max(0, Math.min(100, value)) : 0;
}

function finalPrice(it: Item) {
  const price = Number(it.price || 0);
  const discount = discountPercent(it);
  return discount > 0 ? price * (1 - discount / 100) : price;
}

function normalizedCategoryName(c?: Category | null) {
  return String(c?.name_en || c?.name_ar || "").toLowerCase();
}

function categoryPriority(c?: Category | null) {
  const n = normalizedCategoryName(c);
  if (!n) return 50;
  if (n.includes("breakfast")) return 1;
  if (n.includes("what")) return 2;
  if (n.includes("fresh")) return 3;
  if (n.includes("casserole")) return 4;
  if (n.includes("sandwich")) return 5;
  if (n.includes("burger") || n.includes("sear")) return 6;
  if (n.includes("seafood")) return 7;
  if (n.includes("grill") || n.includes("chef")) return 8;
  if (n.includes("moroccan table")) return 9;
  if (n.includes("moroccan oven")) return 10;
  if (n.includes("italian") || n.includes("pasta")) return 11;
  if (n.includes("melt")) return 12;
  if (n.includes("loaded")) return 13;
  if (n.includes("sweet") || n.includes("dessert") || n.includes("ending")) return 70;
  if (n.includes("coffee")) return 80;
  if (n.includes("beverage") || n.includes("drink") || n.includes("mojito") || n.includes("water")) return 85;
  if (n.includes("sauce")) return 90;
  if (n.includes("add") || n.includes("extra") || n.includes("cheese")) return 95;
  return 40;
}

function isAddOnCategory(c?: Category | null) {
  const n = normalizedCategoryName(c);
  return n.includes("add") || n.includes("extra") || n.includes("sauce") || n.includes("beverage") || n.includes("drink") || n.includes("coffee");
}

export default function MenuPage() {
  const [data, setData] = useState<{ settings: Settings; categories: Category[]; items: Item[]; deliveryLinks: any[] } | null>(null);
  const [lang, setLang] = useState<Lang>("en");
  const [cat, setCat] = useState("all");
  const [q, setQ] = useState("");
  const [cart, setCart] = useState<any[]>([]);
  const [checkout, setCheckout] = useState(false);
  const [slide, setSlide] = useState(0);
  const [form, setForm] = useState({ type: "pickup", name: "", phone: "", table: "", payment: "Cash", notes: "" });

  useEffect(() => {
    fetch("/api/public/menu")
      .then((r) => r.json())
      .then(setData)
      .catch(() => setData({ settings: {}, categories: [], items: [], deliveryLinks: [] }));
  }, []);

  const s = data?.settings || {};
  const dir = lang === "ar" ? "rtl" : "";

  const sortedCategories = useMemo(() => {
    const cats = [...(data?.categories || [])];
    return cats.sort((a, b) => categoryPriority(a) - categoryPriority(b) || Number(a.sort_order || 0) - Number(b.sort_order || 0));
  }, [data?.categories]);

  const categoryMap = useMemo(() => new Map(sortedCategories.map((c) => [c.id, c])), [sortedCategories]);

  const heroSlides = useMemo(() => {
    const custom = [s.hero_image_url, s.hero_image_url_2, s.hero_image_url_3].filter(Boolean);
    return [...custom, ...BUILT_IN_SLIDES].filter(Boolean);
  }, [s.hero_image_url, s.hero_image_url_2, s.hero_image_url_3]);

  useEffect(() => {
    if (heroSlides.length <= 1) return;
    const id = window.setInterval(() => setSlide((v) => (v + 1) % heroSlides.length), 5200);
    return () => window.clearInterval(id);
  }, [heroSlides.length]);

  const allSortedItems = useMemo(() => {
    const items = [...(data?.items || [])];
    return items.sort((a, b) => {
      const ca = categoryMap.get(a.category_id);
      const cb = categoryMap.get(b.category_id);
      return categoryPriority(ca) - categoryPriority(cb) || Number(a.sort_order || 0) - Number(b.sort_order || 0) || itemName(a, "en").localeCompare(itemName(b, "en"));
    });
  }, [data?.items, categoryMap]);

  const items = useMemo(() => {
    const text = q.trim().toLowerCase();
    return allSortedItems.filter((it: Item) => {
      const name = itemName(it, lang).toLowerCase();
      const desc = itemDesc(it, lang).toLowerCase();
      return (cat === "all" || it.category_id === cat) && (!text || name.includes(text) || desc.includes(text));
    });
  }, [allSortedItems, cat, q, lang]);

  const signatureItems = useMemo(() => {
    const candidates = allSortedItems.filter((it) => !isAddOnCategory(categoryMap.get(it.category_id)) && it.is_available !== false);
    const withImages = candidates.filter((it) => it.image_url && !String(it.image_url).includes("/images/items/"));
    const source = withImages.length >= 4 ? withImages : candidates;
    return source.slice(0, 8);
  }, [allSortedItems, categoryMap]);

  const addonCategories = useMemo(() => sortedCategories.filter(isAddOnCategory), [sortedCategories]);
  const foodCategories = useMemo(() => sortedCategories.filter((c) => !isAddOnCategory(c)), [sortedCategories]);

  function add(it: Item) {
    setCart((c) => {
      const ex = c.find((x) => x.id === it.id);
      if (ex) return c.map((x) => (x.id === it.id ? { ...x, qty: x.qty + 1 } : x));
      return [...c, { ...it, qty: 1, note: "" }];
    });
  }

  function changeQty(id: string, delta: number) {
    setCart((c) => c.map((x) => (x.id === id ? { ...x, qty: Math.max(0, x.qty + delta) } : x)).filter((x) => x.qty > 0));
  }

  const total = cart.reduce((sum, x) => sum + finalPrice(x) * x.qty, 0);

  function whatsapp() {
    const title = lang === "ar" ? "طلب جديد من القائمة الرقمية" : "New order from digital menu";
    const lines = [
      title,
      `Restaurant: ${s.name_en || "La cha cha restaurant"}`,
      `Order type: ${form.type}`,
      `Name: ${form.name}`,
      `Phone: ${form.phone}`,
    ];
    if (form.type === "dinein") lines.push(`Table: ${form.table}`);
    if (form.type !== "delivery") lines.push(`Payment: ${form.payment}`);
    lines.push("", "Items:");
    cart.forEach((x) => {
      const discount = discountPercent(x);
      const price = finalPrice(x);
      lines.push(`${x.qty} x ${x.name_en} - AED ${price.toFixed(2)}${discount > 0 ? ` (${discount}% discount)` : ""}${x.note ? ` | Note: ${x.note}` : ""}`);
    });
    lines.push("", `Total: AED ${total.toFixed(2)}`);
    if (form.notes) lines.push(`General notes: ${form.notes}`);
    const raw = (s.whatsapp_number || "+97137227116").replace(/[^0-9]/g, "");
    window.open(`https://wa.me/${raw}?text=${encodeURIComponent(lines.join("\n"))}`, "_blank");
  }

  if (!data) {
    return (
      <main className="luxury-site loading-screen">
        <div className="ambient ambient-one" />
        <div className="ambient ambient-two" />
        <div className="loader-card"><span /> Loading La Cha Cha...</div>
      </main>
    );
  }

  const restaurantName = lang === "ar" ? s.name_ar || s.name_en || "La Cha Cha" : s.name_en || "La Cha Cha";
  const welcome = lang === "ar" ? s.welcome_ar || "مطعم فاخر بتجربة رقمية حديثة وطلب سريع." : s.welcome_en || "A luxury digital menu designed to showcase quality, flavor, and a refined ordering experience.";
  const currentSlide = heroSlides[slide % heroSlides.length] || BUILT_IN_SLIDES[0];
  const addressText = lang === "ar" ? s.address_ar || s.address_en || "Abu Dhabi, UAE" : s.address_en || s.address_ar || "Abu Dhabi, UAE";
  const displayPhone = s.phone_number || s.whatsapp_number || "+971 3 722 7116";
  const telPhone = String(displayPhone).replace(/[^0-9+]/g, "");
  const whatsappRaw = String(s.whatsapp_number || displayPhone || "+97137227116").replace(/[^0-9]/g, "");
  const mapsHref = s.google_maps_url || (addressText ? `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(addressText)}` : "");

  return (
    <main className={`luxury-site ${dir}`} style={{ ["--brand-red" as any]: s.primary_color || "#d60822", ["--brand-dark" as any]: s.secondary_color || "#120508" }}>
      <div className="grain" />
      <div className="ambient ambient-one" />
      <div className="ambient ambient-two" />

      <section className="lux-hero">
        <div className="hero-slider" aria-hidden="true">
          {heroSlides.map((img, index) => (
            <div key={`${img}-${index}`} className={`hero-slide ${index === slide % heroSlides.length ? "active" : ""}`} style={{ backgroundImage: `url(${img})` }} />
          ))}
        </div>
        <div className="hero-shade" />

        <nav className="lux-nav">
          <div className="brand-lockup">
            {s.logo_url ? <img src={s.logo_url} className="lux-logo" alt="Logo" /> : <div className="lux-logo text-logo">LC</div>}
            <div>
              <span className="eyebrow">Luxury Digital Menu</span>
              <h1>{restaurantName}</h1>
            </div>
          </div>
          <div className="nav-cluster">
            <button className="ghost-pill" onClick={() => setLang(lang === "en" ? "ar" : "en")}>{lang === "en" ? "العربية" : "English"}</button>
          </div>
        </nav>

        <div className="hero-grid">
          <div className="hero-message">
            <span className="open-pill"><span /> {s.opening_hours || "00:00 ~ 23:59"}</span>
            <h2>{lang === "ar" ? "فخامة الطعم تبدأ من أول نظرة" : "A premium dining experience from the first look"}</h2>
            <p>{welcome}</p>
            <div className="hero-actions">
              <a href="#menu" className="primary-cta">{lang === "ar" ? "استعرض المنيو" : "Explore menu"}</a>
              <button className="secondary-cta" onClick={() => setCheckout(true)} disabled={!cart.length}>{lang === "ar" ? "عرض الطلب" : "View order"}</button>
            </div>
          </div>

          <div className="search-card">
            <span className="eyebrow dark">Smart Search</span>
            <input placeholder={lang === "ar" ? "ابحث: طاجين، برجر، باستا، قهوة" : "Search: tajine, burger, pasta, coffee"} value={q} onChange={(e) => setQ(e.target.value)} />
            <div className="mini-stats">
              <div><strong>{foodCategories.length}</strong><small>{lang === "ar" ? "أقسام الطعام" : "Food groups"}</small></div>
              <div><strong>{data.items.length}</strong><small>{lang === "ar" ? "عنصر" : "Items"}</small></div>
              <div><strong>AED</strong><small>{lang === "ar" ? "العملة" : "Currency"}</small></div>
            </div>
          </div>
        </div>

        <div className="slide-dots">
          {heroSlides.map((_, index) => <button key={index} className={index === slide % heroSlides.length ? "active" : ""} onClick={() => setSlide(index)} aria-label={`Slide ${index + 1}`} />)}
        </div>
      </section>

      {signatureItems.length > 0 && (
        <section className="signature-section">
          <div className="section-heading">
            <span className="eyebrow dark">Chef Selection</span>
            <h2>{lang === "ar" ? "اختيارات مميزة" : "Signature picks"}</h2>
            <p>{lang === "ar" ? "أول ما يراه العميل يجب أن يعكس جودة وفخامة المطعم." : "A curated first impression that reflects the restaurant’s quality and premium taste."}</p>
          </div>
          <div className="signature-row">
            {signatureItems.map((it) => (
              <button key={it.id} className="signature-card" onClick={() => add(it)}>
                <div>
                  <span>{itemName(it, lang)}</span>
                  <strong>AED {finalPrice(it).toFixed(2)}</strong>
                </div>
                <em>+</em>
              </button>
            ))}
          </div>
        </section>
      )}

      <section id="menu" className="menu-shell">
        <div className="section-heading compact">
          <span className="eyebrow dark">Menu Collection</span>
          <h2>{lang === "ar" ? "القائمة" : "Browse the menu"}</h2>
        </div>

        <div className="category-dock">
          <button className={`category-pill ${cat === "all" ? "active" : ""}`} onClick={() => setCat("all")}>{lang === "ar" ? "الكل" : "All"}</button>
          {foodCategories.map((c) => (
            <button key={c.id} className={`category-pill ${cat === c.id ? "active" : ""}`} onClick={() => setCat(c.id)}>{lang === "ar" ? c.name_ar || c.name_en : c.name_en}</button>
          ))}
          {addonCategories.length > 0 && <span className="dock-divider">{lang === "ar" ? "الإضافات والمشروبات" : "Extras & drinks"}</span>}
          {addonCategories.map((c) => (
            <button key={c.id} className={`category-pill addon ${cat === c.id ? "active" : ""}`} onClick={() => setCat(c.id)}>{lang === "ar" ? c.name_ar || c.name_en : c.name_en}</button>
          ))}
        </div>

        <div className="menu-grid">
          {items.map((it) => {
            const imageLooksLikeSeedCrop = !it.image_url || String(it.image_url).includes("/images/items/");
            const discount = discountPercent(it);
            const category = categoryMap.get(it.category_id);
            return (
              <article key={it.id} className={`menu-card ${!it.is_available ? "sold" : ""}`}>
                <div className="image-stage">
                  {it.image_url && !imageLooksLikeSeedCrop ? (
                    <div className="smart-image">
                      <img className="smart-image-bg" src={it.image_url} alt="" aria-hidden="true" />
                      <img className="smart-image-main" src={it.image_url} alt={itemName(it, lang)} />
                    </div>
                  ) : (
                    <div className="image-soon">
                      <span>{lang === "ar" ? "صورة قريباً" : "Photo soon"}</span>
                      <small>{lang === "ar" ? "ارفع صورة أصلية من الأدمن" : "Upload real photo from admin"}</small>
                    </div>
                  )}
                  {discount > 0 && <div className="discount-ribbon">-{discount}%</div>}
                </div>
                <div className="menu-card-body">
                  <div className="card-meta">
                    <span>{category ? (lang === "ar" ? category.name_ar || category.name_en : category.name_en) : "La Cha Cha"}</span>
                    {discount > 0 && <b>Discount</b>}
                  </div>
                  <h3>{itemName(it, lang)}</h3>
                  <p>{itemDesc(it, lang)}</p>
                  <div className="action-row">
                    <div className="price-stack">
                      {discount > 0 && <span className="old-price">AED {Number(it.price).toFixed(2)}</span>}
                      <strong>AED {finalPrice(it).toFixed(2)}</strong>
                    </div>
                    {it.is_available ? <button className="add-button" onClick={() => add(it)}>{lang === "ar" ? "إضافة" : "Add"}</button> : <span className="sold-text">Unavailable</span>}
                  </div>
                </div>
              </article>
            );
          })}
        </div>
      </section>

      <div className="sticky-contact-dock" aria-label="Contact and location shortcuts">
        <a href={`tel:${telPhone}`} className="dock-action"><span>☎</span><b>{lang === "ar" ? "اتصال" : "Call"}</b></a>
        <a href={`https://wa.me/${whatsappRaw}`} target="_blank" className="dock-action whatsapp"><span>✆</span><b>WhatsApp</b></a>
      </div>

      {cart.length > 0 && (
        <section className="floating-cart">
          <div>
            <span>{lang === "ar" ? "سلة الطلب" : "Your order"}</span>
            <strong>{cart.reduce((n, x) => n + x.qty, 0)} items • AED {total.toFixed(2)}</strong>
          </div>
          <button className="checkout-button" onClick={() => setCheckout(true)}>{lang === "ar" ? "إتمام الطلب" : "Checkout"}</button>
        </section>
      )}

      {checkout && (
        <div className="modal" onClick={() => setCheckout(false)}>
          <div className="modal-card" onClick={(e) => e.stopPropagation()}>
            <h2>{lang === "ar" ? "إتمام الطلب" : "Checkout"}</h2>
            <div className="cart-lines">
              {cart.map((x) => (
                <div className="cart-line" key={x.id}>
                  <div><strong>{itemName(x, lang)}</strong><span>AED {finalPrice(x).toFixed(2)}</span></div>
                  <div className="qty-controls"><button onClick={() => changeQty(x.id, -1)}>-</button><b>{x.qty}</b><button onClick={() => changeQty(x.id, 1)}>+</button></div>
                </div>
              ))}
            </div>
            <div className="form">
              <select className="input" value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })}><option value="pickup">Pickup</option><option value="dinein">Dine-in</option><option value="delivery">Delivery app</option></select>
              <input className="input" placeholder="Name" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
              <input className="input" placeholder="Phone" value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value })} />
              {form.type === "dinein" && <input className="input" placeholder="Table number" value={form.table} onChange={(e) => setForm({ ...form, table: e.target.value })} />}
              {form.type !== "delivery" && <select className="input" value={form.payment} onChange={(e) => setForm({ ...form, payment: e.target.value })}><option>Cash</option><option>Card</option></select>}
              <textarea className="input" placeholder="Notes" value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} />
            </div>
            <div className="modal-actions">
              <button className="checkout-button" onClick={whatsapp}>{lang === "ar" ? "إرسال عبر واتساب" : "Send WhatsApp order"}</button>
              <button className="cancel-button" onClick={() => setCheckout(false)}>Close</button>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}
