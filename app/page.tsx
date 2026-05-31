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

  const items = useMemo(() => {
    if (!data) return [];
    const text = q.trim().toLowerCase();
    return data.items.filter((it: Item) => {
      const name = itemName(it, lang).toLowerCase();
      const desc = itemDesc(it, lang).toLowerCase();
      return (cat === "all" || it.category_id === cat) && (!text || name.includes(text) || desc.includes(text));
    });
  }, [data, cat, q, lang]);

  const featured = useMemo(() => items.slice(0, 6), [items]);

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
      <main className="app-shell loading-screen">
        <div className="orb orb-one" />
        <div className="orb orb-two" />
        <div className="loader-card">Loading La Cha Cha menu...</div>
      </main>
    );
  }

  const restaurantName = lang === "ar" ? s.name_ar || s.name_en || "La Cha Cha" : s.name_en || "La Cha Cha";
  const welcome = lang === "ar" ? s.welcome_ar || "قائمة رقمية بتصميم حديث وتجربة طلب سهلة." : s.welcome_en || "A premium digital menu experience crafted for fast browsing and easy ordering.";
  const heroImage = s.hero_image_url || "/images/hero-banner.png";

  return (
    <main
      className={`app-shell ${dir}`}
      style={{ ["--red" as any]: s.primary_color || "#d20a1e", ["--dark" as any]: s.secondary_color || "#13070b" }}
    >
      <div className="orb orb-one" />
      <div className="orb orb-two" />
      <div className="orb orb-three" />

      <section className="neo-hero" style={{ ["--hero-bg" as any]: `url(${heroImage})` }}>
        <div className="hero-overlay" />
        <nav className="topbar">
          <div className="identity">
            {s.logo_url ? <img src={s.logo_url} className="brand-logo" alt="Logo" /> : <div className="brand-logo text-logo">LC</div>}
            <div>
              <span className="micro-label">Digital Menu</span>
              <h1>{restaurantName}</h1>
            </div>
          </div>
          <div className="nav-actions">
            <button className="chip-button" onClick={() => setLang(lang === "en" ? "ar" : "en")}>{lang === "en" ? "العربية" : "English"}</button>
            {s.google_maps_url && <a className="chip-button" target="_blank" href={s.google_maps_url}>Maps</a>}
          </div>
        </nav>

        <div className="hero-content">
          <div className="hero-copy">
            <span className="status-pill"><span className="live-dot" /> {s.opening_hours || "00:00 ~ 23:59"}</span>
            <h2>{lang === "ar" ? "تجربة منيو فاخرة وسريعة" : "Premium menu, modern ordering"}</h2>
            <p>{welcome}</p>
            <div className="hero-metrics">
              <div><strong>{data.categories.length}</strong><span>{lang === "ar" ? "تصنيف" : "Categories"}</span></div>
              <div><strong>{data.items.length}</strong><span>{lang === "ar" ? "منتج" : "Items"}</span></div>
              <div><strong>AED</strong><span>{lang === "ar" ? "العملة" : "Currency"}</span></div>
            </div>
          </div>

          <div className="hero-panel">
            <label>{lang === "ar" ? "ابحث في المنيو" : "Search the menu"}</label>
            <input className="search-neo" placeholder={lang === "ar" ? "مثال: برجر، باستا، قهوة" : "Try burger, pasta, coffee"} value={q} onChange={(e) => setQ(e.target.value)} />
            <div className="order-types">
              <span>Pickup</span><span>Dine-in</span><span>Delivery</span>
            </div>
          </div>
        </div>
      </section>

      <section className="category-dock">
        <button className={`category-pill ${cat === "all" ? "active" : ""}`} onClick={() => setCat("all")}>{lang === "ar" ? "الكل" : "All"}</button>
        {data.categories.map((c) => (
          <button key={c.id} className={`category-pill ${cat === c.id ? "active" : ""}`} onClick={() => setCat(c.id)}>
            {lang === "ar" ? c.name_ar || c.name_en : c.name_en}
          </button>
        ))}
      </section>

      {featured.length > 0 && (
        <section className="spotlight-strip">
          {featured.map((it) => (
            <button key={it.id} className="spotlight-card" onClick={() => add(it)}>
              <span>{itemName(it, lang)}</span>
              {discountPercent(it) > 0 ? (
                <strong><small>AED {Number(it.price).toFixed(2)}</small> AED {finalPrice(it).toFixed(2)}</strong>
              ) : (
                <strong>AED {Number(it.price).toFixed(2)}</strong>
              )}
            </button>
          ))}
        </section>
      )}

      <section className="menu-grid">
        {items.map((it) => {
          const imageLooksLikeSeedCrop = !it.image_url || String(it.image_url).includes("/images/items/");
          const discount = discountPercent(it);
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
                <div className="card-topline">
                  {it.label && <span className="small-badge">{it.label}</span>}
                  {discount > 0 && <span className="small-badge discount-badge">Discount</span>}
                  {!it.is_available && <span className="small-badge danger">Sold out</span>}
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
      </section>

      {cart.length > 0 && (
        <section className="floating-cart">
          <div>
            <span>{lang === "ar" ? "سلة الطلب" : "Your order"}</span>
            <strong>{cart.length} item(s) • AED {total.toFixed(2)}</strong>
          </div>
          <button className="checkout-button" onClick={() => setCheckout(true)}>{lang === "ar" ? "إتمام الطلب" : "Checkout"}</button>
        </section>
      )}

      {checkout && (
        <div className="modal">
          <div className="modal-card premium-modal">
            <h2>{lang === "ar" ? "تفاصيل الطلب" : "Order details"}</h2>
            <div className="cart-lines">
              {cart.map((x) => (
                <div className="cart-line" key={x.id}>
                  <span>{x.name_en}</span>
                  <span><button onClick={() => changeQty(x.id, -1)}>-</button> {x.qty} <button onClick={() => changeQty(x.id, 1)}>+</button></span>
                </div>
              ))}
            </div>
            <div className="form">
              <select className="input" value={form.type} onChange={(e) => setForm({ ...form, type: e.target.value })}><option value="pickup">Pickup</option><option value="dinein">Dine-in</option><option value="delivery">Delivery</option></select>
              <input className="input" placeholder="Customer name" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
              <input className="input" placeholder="Customer phone" value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value })} />
              {form.type === "dinein" && <input className="input" placeholder="Table number" value={form.table} onChange={(e) => setForm({ ...form, table: e.target.value })} />}
              {form.type !== "delivery" && <select className="input" value={form.payment} onChange={(e) => setForm({ ...form, payment: e.target.value })}><option>Cash</option><option>Card</option></select>}
              <textarea className="input" placeholder="Notes" value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} />
              <div className="modal-actions"><button className="checkout-button" onClick={whatsapp}>Send WhatsApp</button><button className="cancel-button" onClick={() => setCheckout(false)}>Close</button></div>
            </div>
          </div>
        </div>
      )}
    </main>
  );
}
