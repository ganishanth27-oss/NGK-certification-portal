const verifyForm=document.querySelector('#verify-form');
const errorBox=document.querySelector('#verify-error');
const results=document.querySelector('#results');
document.querySelector('#year').textContent=new Date().getFullYear();
verifyForm.addEventListener('submit',async ev=>{
 ev.preventDefault(); errorBox.textContent=''; results.classList.add('hidden');
 const button=verifyForm.querySelector('button'); button.disabled=true; button.innerHTML='<span class="spinner"></span> Looking up certificates…';
 try{
  const data=Object.fromEntries(new FormData(verifyForm));
  const res=await fetch('/api/verify',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)});
  const body=await res.json();
  if(!res.ok) throw new Error(body.error||'We could not find a certificate with those details.');
  results.innerHTML=`<div class="result-heading"><span class="success-check">✓</span><div><h3>Certificates found</h3><p>Verified for <strong>${escapeHtml(body.student_name)}</strong></p></div></div>`+
   body.certificates.map(c=>`<article class="certificate-result"><div class="result-art">✦</div><div class="result-info"><strong>${escapeHtml(c.event_name)}</strong><span>${escapeHtml(c.event_date||'Participation certificate')} · ${escapeHtml(c.certificate_id)}</span></div><div class="result-actions"><a class="button secondary small" target="_blank" rel="noopener" href="${c.view_url}">View</a><a class="button primary small" href="${c.download_url}?download=1">Download</a></div></article>`).join('');
  results.classList.remove('hidden');
 }catch(err){errorBox.textContent=err.message;}
 finally{button.disabled=false;button.innerHTML='Find my certificates <span aria-hidden="true">→</span>';}
});
function escapeHtml(s){return String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));}
