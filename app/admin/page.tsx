"use client";
import { useEffect, useState } from "react";

type Any = any;
const emptyItem={name_en:"",name_ar:"",description_en:"",description_ar:"",price:0,discount_percent:0,category_id:"",image_url:"",is_available:true,is_visible:true,label:"",sort_order:0};

async function normalizeImageForMenu(file: File, target: 'item' | 'settings' | 'hero'): Promise<File> {
  const isHero = target === 'hero';
  const isLogo = target === 'settings';

  const targetWidth = isHero ? 1920 : isLogo ? 900 : 1600;
  const targetHeight = isHero ? 1080 : isLogo ? 900 : 900;

  const imageUrl = URL.createObjectURL(file);
  const img = await new Promise<HTMLImageElement>((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = () => reject(new Error('Could not read image'));
    image.src = imageUrl;
  });

  const canvas = document.createElement('canvas');
  canvas.width = targetWidth;
  canvas.height = targetHeight;
  const ctx = canvas.getContext('2d');
  if (!ctx) throw new Error('Canvas not supported');

  ctx.fillStyle = isLogo ? '#fff7f5' : '#16070b';
  ctx.fillRect(0, 0, targetWidth, targetHeight);

  if (!isHero && !isLogo) {
    // PRODUCT PHOTO MODE V3:
    // The image is converted to the same ratio as the product card.
    // It fills the full card with a smart food-focused crop, instead of placing
    // the original photo as a small square inside a blurred background.
    // This removes empty table/background space and makes uploaded food images look premium.
    const targetAspect = targetWidth / targetHeight;
    const sourceAspect = img.width / img.height;

    let sx = 0;
    let sy = 0;
    let sw = img.width;
    let sh = img.height;

    if (sourceAspect > targetAspect) {
      // Source is too wide: crop left/right.
      sw = img.height * targetAspect;
      sx = (img.width - sw) / 2;
    } else {
      // Source is too tall/square: crop top/bottom.
      // A slightly lower focal point usually keeps plates/food centered
      // and removes decorations/empty space at the top of phone photos.
      sh = img.width / targetAspect;
      const focalY = 0.58;
      sy = Math.max(0, Math.min(img.height - sh, img.height * focalY - sh / 2));
    }

    // First draw a softly blurred version to avoid harsh edges if the crop is imperfect.
    ctx.save();
    ctx.filter = 'blur(18px) saturate(1.12)';
    ctx.globalAlpha = 0.38;
    ctx.drawImage(img, sx, sy, sw, sh, 0, 0, targetWidth, targetHeight);
    ctx.restore();

    // Then draw the sharp card-filling product image.
    ctx.drawImage(img, sx, sy, sw, sh, 0, 0, targetWidth, targetHeight);

    // Premium subtle edge shading so images blend with the luxury card style.
    const shade = ctx.createLinearGradient(0, 0, targetWidth, targetHeight);
    shade.addColorStop(0, 'rgba(0,0,0,0.04)');
    shade.addColorStop(0.55, 'rgba(255,255,255,0.00)');
    shade.addColorStop(1, 'rgba(0,0,0,0.10)');
    ctx.fillStyle = shade;
    ctx.fillRect(0, 0, targetWidth, targetHeight);
  } else {
    // Hero images should fill the hero area; logos should stay fully visible.
    const fit = isLogo ? 'contain' : 'cover';
    const scale = fit === 'cover'
      ? Math.max(targetWidth / img.width, targetHeight / img.height)
      : Math.min((targetWidth - 120) / img.width, (targetHeight - 120) / img.height);
    const drawW = img.width * scale;
    const drawH = img.height * scale;
    const x = (targetWidth - drawW) / 2;
    const y = (targetHeight - drawH) / 2;

    if (isLogo) {
      ctx.save();
      ctx.filter = 'blur(10px)';
      ctx.globalAlpha = 0.14;
      const bgScale = Math.max(targetWidth / img.width, targetHeight / img.height);
      ctx.drawImage(img, (targetWidth - img.width * bgScale) / 2, (targetHeight - img.height * bgScale) / 2, img.width * bgScale, img.height * bgScale);
      ctx.restore();
    }

    ctx.drawImage(img, x, y, drawW, drawH);
  }

  URL.revokeObjectURL(imageUrl);

  const blob = await new Promise<Blob>((resolve, reject) => {
    canvas.toBlob((b) => b ? resolve(b) : reject(new Error('Could not create image')), 'image/webp', 0.94);
  });

  const baseName = file.name.replace(/\.[^.]+$/, '').replace(/[^a-zA-Z0-9-_]+/g, '-').slice(0, 60) || 'menu-image';
  return new File([blob], `${baseName}-${targetWidth}x${targetHeight}-smart-cover.webp`, { type: 'image/webp' });
}


export default function AdminPage(){
  const [session,setSession]=useState<Any>(null); const [login,setLogin]=useState({username:"admin",password:"123"}); const [error,setError]=useState("");
  const [tab,setTab]=useState("settings"); const [settings,setSettings]=useState<Any>({}); const [cats,setCats]=useState<Any[]>([]); const [items,setItems]=useState<Any[]>([]); const [users,setUsers]=useState<Any[]>([]);
  const [item,setItem]=useState<Any>(emptyItem); const [cat,setCat]=useState<Any>({name_en:"",name_ar:"",sort_order:0,is_visible:true}); const [newUser,setNewUser]=useState({username:"",password:"",role:"editor"});
  const [discount,setDiscount]=useState({mode:"selected", percent:10, selectedIds:[] as string[]});

  useEffect(()=>{fetch('/api/admin/me').then(r=>r.json()).then(d=>{setSession(d.session); if(d.session) loadAll();})},[]);
  async function api(url:string, options:Any={}){ const r=await fetch(url,{...options,headers:{'Content-Type':'application/json',...(options.headers||{})}}); const d=await r.json().catch(()=>({})); if(!r.ok) throw new Error(d.error||'Error'); return d; }
  async function doLogin(){ setError(''); try{ const d=await api('/api/admin/login',{method:'POST',body:JSON.stringify(login)}); setSession(d); loadAll(); }catch(e:any){setError(e.message)} }
  async function loadAll(){ const [s,c,i]=await Promise.all([fetch('/api/admin/settings').then(r=>r.json()),fetch('/api/admin/categories').then(r=>r.json()),fetch('/api/admin/items').then(r=>r.json())]); setSettings(s); setCats(c); setItems(i); fetch('/api/admin/users').then(r=>r.ok?r.json():[]).then(setUsers); }
  async function saveSettings(){ await api('/api/admin/settings',{method:'PUT',body:JSON.stringify(settings)}); alert('Settings saved'); }
  async function saveCat(){ await api('/api/admin/categories',{method:cat.id?'PUT':'POST',body:JSON.stringify(cat)}); setCat({name_en:"",name_ar:"",sort_order:0,is_visible:true}); loadAll(); }
  async function delCat(id:string){ if(confirm('Delete category?')){ await api('/api/admin/categories',{method:'DELETE',body:JSON.stringify({id})}); loadAll(); } }
  async function saveItem(){ await api('/api/admin/items',{method:item.id?'PUT':'POST',body:JSON.stringify(item)}); setItem(emptyItem); loadAll(); }
  async function delItem(id:string){ if(confirm('Delete item?')){ await api('/api/admin/items',{method:'DELETE',body:JSON.stringify({id})}); loadAll(); } }
  async function upload(e:any, target:'item'|'settings'|'hero'){
    const input = e.target as HTMLInputElement;
    const file=input.files?.[0];
    if(!file) return;
    try{
      const normalized = await normalizeImageForMenu(file, target);
      const form=new FormData();
      form.append('file',normalized);
      const r=await fetch('/api/admin/upload',{method:'POST',body:form});
      const d=await r.json();
      if(!r.ok) return alert(d.error);
      target==='item'?setItem({...item,image_url:d.url}):target==='hero'?setSettings({...settings,hero_image_url:d.url}):setSettings({...settings,logo_url:d.url});
      input.value = '';
    }catch(err:any){
      alert(err?.message || 'Image processing failed');
    }
  }
  async function addUser(){ await api('/api/admin/users',{method:'POST',body:JSON.stringify(newUser)}); setNewUser({username:"",password:"",role:"editor"}); loadAll(); }
  function toggleDiscountItem(id:string){ setDiscount(d=>({ ...d, selectedIds: d.selectedIds.includes(id) ? d.selectedIds.filter(x=>x!==id) : [...d.selectedIds,id] })); }
  function selectAllDiscount(){ setDiscount(d=>({ ...d, selectedIds: items.map(x=>x.id) })); }
  function clearDiscountSelection(){ setDiscount(d=>({ ...d, selectedIds: [] })); }
  async function saveDiscount(){ const ids = discount.mode === 'all' ? items.map(x=>x.id) : discount.selectedIds; if(!ids.length) return alert('Choose at least one item or choose all items.'); await api('/api/admin/discount',{method:'POST',body:JSON.stringify({ itemIds: ids, discount_percent: Number(discount.percent || 0) })}); alert('Discount saved'); loadAll(); }
  async function removeDiscount(){ const ids = discount.mode === 'all' ? items.map(x=>x.id) : discount.selectedIds; if(!ids.length) return alert('Choose at least one item or choose all items.'); await api('/api/admin/discount',{method:'POST',body:JSON.stringify({ itemIds: ids, discount_percent: 0 })}); alert('Discount removed'); loadAll(); }

  if(!session) return <main className="container"><section className="panel" style={{maxWidth:420,margin:'60px auto'}}><h1>Admin Login</h1><div className="form"><input className="input" placeholder="Username" value={login.username} onChange={e=>setLogin({...login,username:e.target.value})}/><input className="input" placeholder="Password" type="password" value={login.password} onChange={e=>setLogin({...login,password:e.target.value})}/>{error&&<p style={{color:'red'}}>{error}</p>}<button className="btn red" onClick={doLogin}>Login</button><p className="tiny">Default testing login: admin / 123. Change it before public launch.</p></div></section></main>;
  return <main className="admin-layout"><aside className="sidebar"><h2>La Cha Cha Admin</h2><p className="tiny">Logged in as {session.username}</p>{['settings','categories','items','discount','users'].map(x=><button key={x} className={`btn ${tab===x?'red':''}`} onClick={()=>setTab(x)}>{x.toUpperCase()}</button>)}<button className="btn light" onClick={()=>fetch('/api/admin/logout',{method:'POST'}).then(()=>location.reload())}>Logout</button></aside><section className="admin-main">
  {tab==='settings'&&<div className="panel"><h1>Website / Restaurant Settings</h1><div className="row"><input className="input" placeholder="Restaurant name EN" value={settings.name_en||''} onChange={e=>setSettings({...settings,name_en:e.target.value})}/><input className="input" placeholder="Restaurant name AR" value={settings.name_ar||''} onChange={e=>setSettings({...settings,name_ar:e.target.value})}/><input className="input" placeholder="WhatsApp number" value={settings.whatsapp_number||''} onChange={e=>setSettings({...settings,whatsapp_number:e.target.value})}/><input className="input" placeholder="Phone number" value={settings.phone_number||''} onChange={e=>setSettings({...settings,phone_number:e.target.value})}/><input className="input" placeholder="Opening hours" value={settings.opening_hours||''} onChange={e=>setSettings({...settings,opening_hours:e.target.value})}/><input className="input" placeholder="Currency" value={settings.currency||'AED'} onChange={e=>setSettings({...settings,currency:e.target.value})}/><input className="input" placeholder="Primary color" value={settings.primary_color||''} onChange={e=>setSettings({...settings,primary_color:e.target.value})}/><input className="input" placeholder="Secondary color" value={settings.secondary_color||''} onChange={e=>setSettings({...settings,secondary_color:e.target.value})}/><input className="input" placeholder="Google Maps URL" value={settings.google_maps_url||''} onChange={e=>setSettings({...settings,google_maps_url:e.target.value})}/><input className="input" placeholder="Address EN" value={settings.address_en||''} onChange={e=>setSettings({...settings,address_en:e.target.value})}/><input className="input" placeholder="Address AR" value={settings.address_ar||''} onChange={e=>setSettings({...settings,address_ar:e.target.value})}/><input className="input" placeholder="Instagram URL" value={settings.instagram_url||''} onChange={e=>setSettings({...settings,instagram_url:e.target.value})}/><input className="input" placeholder="TikTok URL" value={settings.tiktok_url||''} onChange={e=>setSettings({...settings,tiktok_url:e.target.value})}/><input className="input" placeholder="Snapchat URL" value={settings.snapchat_url||''} onChange={e=>setSettings({...settings,snapchat_url:e.target.value})}/><input className="input" placeholder="Talabat URL" value={settings.talabat_url||''} onChange={e=>setSettings({...settings,talabat_url:e.target.value})}/><input className="input" placeholder="Hero background URL" value={settings.hero_image_url||''} onChange={e=>setSettings({...settings,hero_image_url:e.target.value})}/></div><div className="form" style={{marginTop:12}}><textarea className="input" placeholder="Welcome message EN" value={settings.welcome_en||''} onChange={e=>setSettings({...settings,welcome_en:e.target.value})}/><textarea className="input" placeholder="Welcome message AR" value={settings.welcome_ar||''} onChange={e=>setSettings({...settings,welcome_ar:e.target.value})}/><label>Upload / replace logo <input type="file" accept="image/*" onChange={e=>upload(e,'settings')}/></label>{settings.logo_url&&<img src={settings.logo_url} style={{maxWidth:120,borderRadius:16}}/>}<label>Upload / replace homepage banner <input type="file" accept="image/*" onChange={e=>upload(e,'hero')}/></label>{settings.hero_image_url&&<img src={settings.hero_image_url} style={{maxWidth:240,borderRadius:16}}/>}<button className="btn red" onClick={saveSettings}>Save Settings</button></div></div>}
  {tab==='categories'&&<div className="panel"><h1>Categories</h1><div className="row"><input className="input" placeholder="Name EN" value={cat.name_en||''} onChange={e=>setCat({...cat,name_en:e.target.value})}/><input className="input" placeholder="Name AR" value={cat.name_ar||''} onChange={e=>setCat({...cat,name_ar:e.target.value})}/><input className="input" type="number" placeholder="Sort" value={cat.sort_order||0} onChange={e=>setCat({...cat,sort_order:Number(e.target.value)})}/><select className="input" value={String(cat.is_visible)} onChange={e=>setCat({...cat,is_visible:e.target.value==='true'})}><option value="true">Visible</option><option value="false">Hidden</option></select></div><button className="btn red" onClick={saveCat}>{cat.id?'Update':'Add'} Category</button><table className="table"><tbody>{cats.map(c=><tr key={c.id}><td>{c.name_en}<br/><span className="tiny">{c.name_ar}</span></td><td>{c.is_visible?'Visible':'Hidden'}</td><td><button onClick={()=>setCat(c)}>Edit</button> <button onClick={()=>delCat(c.id)}>Delete</button></td></tr>)}</tbody></table></div>}
  {tab==='items'&&<div className="panel"><h1>Menu Items</h1><div className="row"><input className="input" placeholder="Name EN" value={item.name_en||''} onChange={e=>setItem({...item,name_en:e.target.value})}/><input className="input" placeholder="Name AR" value={item.name_ar||''} onChange={e=>setItem({...item,name_ar:e.target.value})}/><select className="input" value={item.category_id||''} onChange={e=>setItem({...item,category_id:e.target.value})}><option value="">Choose category</option>{cats.map(c=><option key={c.id} value={c.id}>{c.name_en}</option>)}</select><input className="input" type="number" step="0.01" placeholder="Price" value={item.price||0} onChange={e=>setItem({...item,price:Number(e.target.value)})}/><input className="input" type="number" step="1" min="0" max="100" placeholder="Discount %" value={item.discount_percent||0} onChange={e=>setItem({...item,discount_percent:Number(e.target.value)})}/><input className="input" placeholder="Label" value={item.label||''} onChange={e=>setItem({...item,label:e.target.value})}/><input className="input" type="number" placeholder="Sort" value={item.sort_order||0} onChange={e=>setItem({...item,sort_order:Number(e.target.value)})}/><select className="input" value={String(item.is_available)} onChange={e=>setItem({...item,is_available:e.target.value==='true'})}><option value="true">Available</option><option value="false">Sold out</option></select><select className="input" value={String(item.is_visible)} onChange={e=>setItem({...item,is_visible:e.target.value==='true'})}><option value="true">Visible</option><option value="false">Hidden</option></select></div><div className="form" style={{marginTop:12}}><textarea className="input" placeholder="Description EN" value={item.description_en||''} onChange={e=>setItem({...item,description_en:e.target.value})}/><textarea className="input" placeholder="Description AR" value={item.description_ar||''} onChange={e=>setItem({...item,description_ar:e.target.value})}/><input className="input" placeholder="Image URL" value={item.image_url||''} onChange={e=>setItem({...item,image_url:e.target.value})}/><label>Upload item image <input type="file" accept="image/*" onChange={e=>upload(e,'item')}/></label>{item.image_url&&<img src={item.image_url} className="admin-image-preview"/>}<button className="btn red" onClick={saveItem}>{item.id?'Update':'Add'} Item</button><button className="btn ghost" onClick={()=>setItem(emptyItem)}>Clear</button></div><table className="table"><tbody>{items.map(it=><tr key={it.id}><td>{it.image_url&&<img src={it.image_url} className="admin-thumb"/>}</td><td>{it.name_en}<br/><span className="tiny">AED {Number(it.price).toFixed(2)} {Number(it.discount_percent||0)>0 && ` | Discount ${it.discount_percent}%`}</span></td><td>{it.is_available?'Available':'Sold out'} / {it.is_visible?'Visible':'Hidden'}</td><td><button onClick={()=>setItem(it)}>Edit</button> <button onClick={()=>delItem(it.id)}>Delete</button></td></tr>)}</tbody></table></div>}
  {tab==='discount'&&<div className="panel"><h1>Discount Management</h1><p className="tiny">Apply a discount to all items or choose selected items from the list.</p><div className="row"><select className="input" value={discount.mode} onChange={e=>setDiscount({...discount,mode:e.target.value,selectedIds:e.target.value==='all'?items.map(x=>x.id):discount.selectedIds})}><option value="selected">Selected items only</option><option value="all">All items</option></select><input className="input" type="number" min="0" max="100" step="1" placeholder="Discount percentage" value={discount.percent} onChange={e=>setDiscount({...discount,percent:Number(e.target.value)})}/></div><div className="discount-toolbar"><button className="btn red" onClick={saveDiscount}>Save discount</button><button className="btn ghost" onClick={removeDiscount}>Remove discount</button><button className="btn ghost" onClick={selectAllDiscount}>Select all</button><button className="btn ghost" onClick={clearDiscountSelection}>Clear selection</button></div><div className="discount-list"><label className="discount-check all-check"><input type="checkbox" checked={discount.mode==='all'} onChange={e=>setDiscount({...discount,mode:e.target.checked?'all':'selected',selectedIds:e.target.checked?items.map(x=>x.id):[]})}/> Apply to ALL items</label>{items.map(it=><label className="discount-check" key={it.id}><input type="checkbox" checked={discount.mode==='all'||discount.selectedIds.includes(it.id)} onChange={()=>toggleDiscountItem(it.id)} disabled={discount.mode==='all'}/><span>{it.name_en}</span><small>AED {Number(it.price).toFixed(2)} {Number(it.discount_percent||0)>0?`• Current ${it.discount_percent}%`:''}</small></label>)}</div></div>}
  {tab==='users'&&<div className="panel"><h1>Users and Passwords</h1><p className="tiny">Only owner can manage users. Create manager/editor/viewer accounts here.</p><div className="row"><input className="input" placeholder="Username" value={newUser.username} onChange={e=>setNewUser({...newUser,username:e.target.value})}/><input className="input" placeholder="Password" value={newUser.password} onChange={e=>setNewUser({...newUser,password:e.target.value})}/><select className="input" value={newUser.role} onChange={e=>setNewUser({...newUser,role:e.target.value})}><option value="owner">Owner</option><option value="manager">Manager</option><option value="editor">Menu Editor</option><option value="viewer">Viewer</option></select></div><button className="btn red" onClick={addUser}>Add User</button><table className="table"><tbody>{users.map(u=><tr key={u.id}><td>{u.username}</td><td>{u.role}</td><td>{u.is_active?'Active':'Disabled'}</td></tr>)}</tbody></table></div>}
  </section></main>
}
