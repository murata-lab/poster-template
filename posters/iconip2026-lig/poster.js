const qr = qrcode(0, 'M');
qr.addData('https://eightsuzuki.github.io/layer-wise-integrated-gradients/');  // same URL as printed under the code
qr.make();
document.getElementById('qr').innerHTML = qr.createSvgTag({ scalable: true, margin: 0 });
// small QR codes in the header (poster PDF, author page): URL comes from data-qr
document.querySelectorAll('[data-qr]').forEach(el => {
  const q = qrcode(0, 'M'); q.addData(el.dataset.qr); q.make();
  el.innerHTML = q.createSvgTag({ scalable: true, margin: 0 });
});
window.addEventListener('load', async () => {
  renderMathInElement(document.body, { ignoredClasses: ['nomath'], delimiters: [
    { left: '$$', right: '$$', display: true }, { left: '$', right: '$', display: false } ] });
  // web fonts (BIZ UDPGothic, KaTeX) reflow the columns when they arrive; measure after that
  await document.fonts.ready;
  // Column overflow is clipped, not paginated, so flag it where `make` can grep for it
  // also catch anything (e.g. a too-long header line) that widens the page
  const m = document.querySelector('main'), b = document.body;
  if (m.scrollWidth > m.clientWidth + 1 || m.scrollHeight > m.clientHeight + 1 || b.scrollWidth > b.clientWidth + 1)
  {
    // name the widest offender so the fix is obvious
    const W = b.clientWidth, bad = [...document.querySelectorAll('body *')].find(e => !e.closest('.katex') && e.getBoundingClientRect().right > W + 1);
    const who = bad ? ` (${bad.tagName.toLowerCase()}.${bad.className || ''}: ${(bad.textContent || '').trim().slice(0, 40)})` : '';
    document.body.insertAdjacentHTML('beforeend', '<div id="overflow">OVERFLOW: content does not fit' + who + '</div>');
  }
});
