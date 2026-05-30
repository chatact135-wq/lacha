"use client";
import { useEffect, useMemo, useState } from "react";

type Settings = any; type Category = any; type Item = any;

export default function MenuPage(){
  const [data,setData]=useState<{settings:Settings,categories:Category[],items:Item[],deliveryLinks:any[]}|null>(null);
  const [lang,setLang]=useState<"en"|"ar">("en");
  const [cat,setCat]=useState("all");
  const [q,setQ]=useState("");
  const [cart,setCart]=useState<any[]>([]);
  const [checkout,setCheckout]=useState(false);
  const [form,setForm]=useState({type:"pickup",name:"",phone:"",table:"",payment:"Cash",notes:""});
  useEffect(()=>{fetch('/api/public/menu').then(r=>r.json()).then(setData)},[]);
  const s=data?.settings||{};
  const dir=lang==='ar'?'rtl':'';
  const items=useMemo(()=>{
    if(!data) return [];
    return data.items.filter((it:Item)=>{
      const name=(lang==='ar'?it.name_ar:it.name_en)||it.name_en||'';
      return (cat==='all'||it.category_id===cat) && name.toLowerCase().includes(q.toLowerCase());
    });
  },[data,cat,q,lang]);
  function add(it:Item){ setCart(c=>{const ex=c.find(x=>x.id===it.id); if(ex) return c.map(x=>x.id===it.id?{...x,qty:x.qty+1}:x); return [...c,{...it,qty:1,note:""}];}); }
  function changeQty(id:string,delta:number){ setCart(c=>c.map(x=>x.id===id?{...x,qty:Math.max(0,x.qty+delta)}:x).filter(x=>x.qty>0)); }
  const total=cart.reduce((sum,x)=>sum+Number(x.price||0)*x.qty,0);
  function whatsapp(){
    const title=lang==='ar'?'طلب جديد من القائمة الرقمية':'New order from digital menu';
    const lines=[title,`Restaurant: ${s.name_en||'La cha cha restaurant'}`,`Order type: ${form.type}`,`Name: ${form.name}`,`Phone: ${form.phone}`];
    if(form.type==='dinein') lines.push(`Table: ${form.table}`);
    if(form.type!=='delivery') lines.push(`Payment: ${form.payment}`);
    lines.push('', 'Items:');
    cart.forEach(x=>lines.push(`${x.qty} x ${x.name_en} - AED ${Number(x.price).toFixed(2)}${x.note?` | Note: ${x.note}`:''}`));
    lines.push('',`Total: AED ${total.toFixed(2)}`);
    if(form.notes) lines.push(`General notes: ${form.notes}`);
    const raw=(s.whatsapp_number||'+97137227116').replace(/[^0-9]/g,'');
    window.open(`https://wa.me/${raw}?text=${encodeURIComponent(lines.join('\n'))}`,'_blank');
  }
  if(!data) return <main className="container">Loading menu...</main>;
  return <main className={`container ${dir}`} style={{['--red' as any]:s.primary_color||'#b41421',['--dark' as any]:s.secondary_color||'#111'}}>
    <section className="hero">
      <div className="hero-top">
        <div className="brand">
          {s.logo_url?<img src={s.logo_url} className="logo"/>:<div className="logo">LC</div>}
          <div><div className="pill">{s.opening_hours||'00:00 ~ 23:59'}</div><h1>{lang==='ar'?(s.name_ar||s.name_en):s.name_en}</h1><p>{lang==='ar'?(s.welcome_ar||s.welcome_en):s.welcome_en}</p></div>
        </div>
        <div className="controls"><button className="btn light" onClick={()=>setLang(lang==='en'?'ar':'en')}>{lang==='en'?'العربية':'English'}</button>{s.google_maps_url&&<a className="btn light" target="_blank" href={s.google_maps_url}>Google Maps</a>}</div>
      </div>
      <div className="controls"><input className="search" placeholder={lang==='ar'?'ابحث في القائمة':'Search menu'} value={q} onChange={e=>setQ(e.target.value)}/></div>
    </section>
    <div className="tabs"><button className={`tab ${cat==='all'?'active':''}`} onClick={()=>setCat('all')}>{lang==='ar'?'الكل':'All'}</button>{data.categories.map(c=><button key={c.id} className={`tab ${cat===c.id?'active':''}`} onClick={()=>setCat(c.id)}>{lang==='ar'?(c.name_ar||c.name_en):c.name_en}</button>)}</div>
    <section className="grid">{items.map(it=><article key={it.id} className={`card ${!it.is_available?'sold':''}`}><div className="food-img">{it.image_url?<img src={it.image_url}/>:<span>{lang==='ar'?'صورة قريباً':'Image soon'}</span>}</div><div className="card-body"><div>{it.label&&<span className="badge">{it.label}</span>}</div><h3>{lang==='ar'?(it.name_ar||it.name_en):it.name_en}</h3><p className="desc">{lang==='ar'?(it.description_ar||it.description_en):it.description_en}</p><div className="price-row"><span className="price">AED {Number(it.price).toFixed(2)}</span>{it.is_available?<button className="btn red" onClick={()=>add(it)}>{lang==='ar'?'إضافة':'Add'}</button>:<span className="badge">Sold out</span>}</div></div></article>)}</section>
    {cart.length>0&&<section className="cart"><div className="cart-row"><strong>{cart.length} item(s) • AED {total.toFixed(2)}</strong><button className="btn red" onClick={()=>setCheckout(true)}>{lang==='ar'?'إرسال الطلب':'Checkout / WhatsApp'}</button></div><div className="cart-items">{cart.map(x=><div className="cart-item" key={x.id}><span>{x.name_en}</span><span><button onClick={()=>changeQty(x.id,-1)}>-</button> {x.qty} <button onClick={()=>changeQty(x.id,1)}>+</button></span></div>)}</div></section>}
    {checkout&&<div className="modal"><div className="modal-card"><h2>{lang==='ar'?'تفاصيل الطلب':'Order details'}</h2><div className="form"><select className="input" value={form.type} onChange={e=>setForm({...form,type:e.target.value})}><option value="pickup">Pickup</option><option value="dinein">Dine-in</option><option value="delivery">Delivery</option></select><input className="input" placeholder="Customer name" value={form.name} onChange={e=>setForm({...form,name:e.target.value})}/><input className="input" placeholder="Customer phone" value={form.phone} onChange={e=>setForm({...form,phone:e.target.value})}/>{form.type==='dinein'&&<input className="input" placeholder="Table number" value={form.table} onChange={e=>setForm({...form,table:e.target.value})}/>} {form.type!=='delivery'&&<select className="input" value={form.payment} onChange={e=>setForm({...form,payment:e.target.value})}><option>Cash</option><option>Card</option></select>}<textarea className="input" placeholder="Notes" value={form.notes} onChange={e=>setForm({...form,notes:e.target.value})}/>{form.type==='delivery'&&<p className="tiny">Delivery can be completed through delivery apps such as Talabat, Deliveroo, Careem, or WhatsApp confirmation.</p>}<button className="btn red" onClick={whatsapp}>Send on WhatsApp</button><button className="btn ghost" onClick={()=>setCheckout(false)}>Cancel</button></div></div></div>}
  </main>
}
