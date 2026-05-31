"use client";
import { useEffect, useMemo, useState } from "react";

type Settings = any;
type Category = any;
type Item = any;

function itemName(it: Item, lang: "en" | "ar") {
  return (lang === "ar" ? it.name_ar || it.name_en : it.name_en || it.name_ar) || "Menu item";
}

function itemDesc(it: Item, lang: "en" | "ar") {
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

function imageIsPlaceholder(url?: string) {
  if (!url) return true;
  const u = String(url);
  return u.includes("/images/items/") || u.includes("placeholder") || u.includes("Photo soon");
}

export default function MenuPage() {
  const [data, setData] = useState<{ settings: Settings; categories: Category[]; items: Item[]; deliveryLinks: any[] } | null>(null);
  const [lang, setLang] = useState<"en" | "ar">("en");
  const [cat, setCat] = useState("all");
  const [q, setQ] = useState("");
  const [cart, setCart] = useState<any[]>([]);
  const [checkout, setCheckout] = useState(false);
  const [form, setForm] = useState({ type: "pickup", name: "", phone: "", table: "", payment: "Cash", notes: "" });

  useEffect(() => {
    fetch("/api/public/menu")
      .then((r) => r.json())
      .then(setData)
      .catch(() => setData({ settings: {}, categories: [], items: [], deliveryLinks: [] }));
  }, []);

  const s = data?.settings || {};
  const dir = lang === "ar" ? "rtl" : "";

  const visibleItems = useMemo(() => {
    if (!data) return [];
    return data.items.filter((it: Item) => it.is_visible !== false);
  }, [data]);

  const items = useMemo(() => {
    const text = q.trim().toLowerCase();
    return visibleItems.filter((it: Item) => {
      const name = itemName(it, lang).toLowerCase();
      const desc = itemDesc(it, lang).toLowerCase();
      return (cat === "all" || it.category_id === cat) && (!text || name.includes(text) || desc.includes(text));
    });
  }, [visibleItems, cat, q, lang]);

  const featured = useMemo(() => {
    const discounted = visibleItems.filter((it: Item) => discountPercent(it) > 0 && it.is_available !== false);
    const withPhotos = visibleItems.filter((it: Item) => !imageIsPlaceholder(it.image_url) && it.is_available !== false);
    const pool = [...discounted, ...withPhotos, ...visibleItems].filter((it, index, arr) => arr.findIndex((x) => x.id === it.id) === index);
    return pool.slice(0, 6);
  }, [visibleItems]);

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
      <main className="lux-page loading-screen">
        <div className="lux-loader"><span /> Loading La Cha Cha</div>
      </main>
    );
  }

  const restaurantName = lang === "ar" ? s.name_ar || s.name_en || "La Cha Cha" : s.name_en || "La Cha Cha";
  const welcome = lang === "ar" ? s.welcome_ar || "قائمة رقمية فاخرة، تصفح سريع، وطلب مباشر." : s.welcome_en || "A premium digital menu crafted for cravings, speed, and effortless ordering.";
  const heroImage = s.hero_image_url || "/images/hero-banner.png";

  return (
    <main className={`lux-page ${dir}`} style={{ ["--red" as any]: s.primary_color || "#d20a1e", ["--dark" as any]: s.secondary_color || "#110509", ["--hero-bg" as any]: `url(${heroImage})` }}>
      <section className="lux-hero">
        <div className="hero-bg" />
        <div className="hero-noise" />
        <nav className="lux-nav">
          <div className="lux-brand">
            {s.logo_url ? <img src={s.logo_url} alt="Logo" /> : <strong>LC</strong>}
            <div>
              <span>{lang === "ar" ? "منيو رقمي فاخر" : "Premium Digital Menu"}</span>
              <b>{restaurantName}</b>
            </div>
          </div>
          <div className="lux-actions">
            <button onClick={() => setLang(lang === "en" ? "ar" : "en")}>{lang === "en" ? "العربية" : "English"}</button>
            {s.google_maps_url && <a href={s.google_maps_url} target="_blank">Maps</a>}
          </div>
        </nav>

        <div className="hero-inner">
          <div className="hero-text">
            <div className="hero-kicker"><span className="pulse" /> {s.opening_hours || "00:00 ~ 23:59"}</div>
            <h1>{lang === "ar" ? "نكهات مميزة بتجربة طلب فاخرة" : "Food that looks irresistible from the first glance"}</h1>
            <p>{welcome}</p>
            <div className="hero-cta-row">
              <a href="#menu" className="primary-cta">{lang === "ar" ? "تصفح المنيو" : "Explore Menu"}</a>
              <button className="secondary-cta" onClick={() => setCheckout(true)} disabled={cart.length === 0}>{lang === "ar" ? "سلة الطلب" : "My Order"}</button>
            </div>
          </div>

          <div className="hero-glass-card">
            <div className="glass-title">
              <span>{lang === "ar" ? "بحث سريع" : "Quick Search"}</span>
              <b>{data.items.length} {lang === "ar" ? "منتج" : "items"}</b>
            </div>
            <input placeholder={lang === "ar" ? "ابحث: برجر، باستا، قهوة" : "Search: burger, pasta, coffee"} value={q} onChange={(e) => setQ(e.target.value)} />
            <div className="glass-tags"><span>Pickup</span><span>Dine-in</span><span>Delivery</span></div>
          </div>
        </div>
      </section>

      <section className="experience-bar">
        <div><strong>{data.categories.length}</strong><span>{lang === "ar" ? "تصنيف" : "Categories"}</span></div>
        <div><strong>{visibleItems.length}</strong><span>{lang === "ar" ? "منتج" : "Menu items"}</span></div>
        <div><strong>AED</strong><span>{lang === "ar" ? "أسعار واضحة" : "Clear prices"}</span></div>
        <div><strong>WhatsApp</strong><span>{lang === "ar" ? "طلب مباشر" : "Fast ordering"}</span></div>
      </section>

      <section className="menu-wrap" id="menu">
        <div className="section-heading">
          <span>{lang === "ar" ? "اختيارك اليوم" : "Choose your craving"}</span>
          <h2>{lang === "ar" ? "منيو لا تشا تشا" : "La Cha Cha Menu"}</h2>
        </div>

        <div className="lux-category-scroll">
          <button className={cat === "all" ? "active" : ""} onClick={() => setCat("all")}>{lang === "ar" ? "الكل" : "All"}</button>
          {data.categories.map((c) => (
            <button key={c.id} className={cat === c.id ? "active" : ""} onClick={() => setCat(c.id)}>
              {lang === "ar" ? c.name_ar || c.name_en : c.name_en}
            </button>
          ))}
        </div>

        {featured.length > 0 && cat === "all" && !q.trim() && (
          <div className="featured-row">
            {featured.map((it) => {
              const discount = discountPercent(it);
              return (
                <button className="featured-tile" key={it.id} onClick={() => add(it)}>
                  <span>{discount > 0 ? `-${discount}%` : "Popular"}</span>
                  <b>{itemName(it, lang)}</b>
                  <em>AED {finalPrice(it).toFixed(2)}</em>
                </button>
              );
            })}
          </div>
        )}

        <div className="lux-grid">
          {items.map((it) => {
            const discount = discountPercent(it);
            const hasPhoto = !imageIsPlaceholder(it.image_url);
            return (
              <article className={`lux-card ${!it.is_available ? "not-available" : ""}`} key={it.id}>
                <div className="photo-box">
                  {hasPhoto ? (
                    <>
                      <img className="photo-blur" src={it.image_url} alt="" aria-hidden="true" />
                      <img className="photo-main" src={it.image_url} alt={itemName(it, lang)} />
                    </>
                  ) : (
                    <div className="photo-soon"><b>Photo soon</b><span>Upload real product photo</span></div>
                  )}
                  {discount > 0 && <span className="deal-badge">-{discount}%</span>}
                </div>
                <div className="lux-card-body">
                  <div className="mini-row">
                    {discount > 0 && <span>Special Offer</span>}
                    {it.label && <span>{it.label}</span>}
                    {!it.is_available && <span>Sold out</span>}
                  </div>
                  <h3>{itemName(it, lang)}</h3>
                  <p>{itemDesc(it, lang)}</p>
                  <div className="price-action">
                    <div className="price">
                      {discount > 0 && <small>AED {Number(it.price).toFixed(2)}</small>}
                      <strong>AED {finalPrice(it).toFixed(2)}</strong>
                    </div>
                    {it.is_available ? <button onClick={() => add(it)}>{lang === "ar" ? "إضافة" : "Add"}</button> : <em>Unavailable</em>}
                  </div>
                </div>
              </article>
            );
          })}
        </div>

        {items.length === 0 && <div className="empty-lux">{lang === "ar" ? "لا توجد نتائج" : "No matching items found"}</div>}
      </section>

      {cart.length > 0 && (
        <section className="lux-cart-bar">
          <div><span>{lang === "ar" ? "سلة الطلب" : "Your order"}</span><strong>{cart.length} items • AED {total.toFixed(2)}</strong></div>
          <button onClick={() => setCheckout(true)}>{lang === "ar" ? "إكمال الطلب" : "Checkout"}</button>
        </section>
      )}

      {checkout && (
        <div className="lux-modal">
          <div className="lux-modal-card">
            <button className="x" onClick={() => setCheckout(false)}>×</button>
            <h2>{lang === "ar" ? "إتمام الطلب" : "Complete your order"}</h2>
            <div className="cart-list">
              {cart.map((x) => (
                <div key={x.id} className="cart-line">
                  <div><b>{itemName(x, lang)}</b><span>AED {finalPrice(x).toFixed(2)}</span></div>
                  <div className="qty"><button onClick={() => changeQty(x.id, -1)}>-</button><strong>{x.qty}</strong><button onClick={() => changeQty(x.id, 1)}>+</button></div>
                </div>
              ))}
            </div>
            <div className="checkout-form">
              <select value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })}><option value="pickup">Pickup</option><option value="dinein">Dine-in</option><option value="delivery">Delivery</option></select>
              <input placeholder="Name" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
              <input placeholder="Phone" value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value })} />
              {form.type === "dinein" && <input placeholder="Table number" value={form.table} onChange={(e) => setForm({ ...form, table: e.target.value })} />}
              {form.type !== "delivery" && <select value={form.payment} onChange={(e) => setForm({ ...form, payment: e.target.value })}><option>Cash</option><option>Card</option></select>}
              <textarea placeholder="Notes" value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} />
            </div>
            <button className="send-order" disabled={cart.length === 0} onClick={whatsapp}>{lang === "ar" ? "إرسال عبر واتساب" : "Send order on WhatsApp"} • AED {total.toFixed(2)}</button>
          </div>
        </div>
      )}
    </main>
  );
}
