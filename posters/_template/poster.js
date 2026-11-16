// QR codes: every <div data-qr="URL"> becomes a QR code for that URL.
document.querySelectorAll('[data-qr]').forEach(el => {
  const q = qrcode(0, 'M'); q.addData(el.dataset.qr); q.make();
  el.innerHTML = q.createSvgTag({ scalable: true, margin: 0 });
});

window.addEventListener('load', async () => {
  // Math: $...$ inline, $$...$$ display. Add class="nomath" to anything that contains a literal $.
  renderMathInElement(document.body, { ignoredClasses: ['nomath'], delimiters: [
    { left: '$$', right: '$$', display: true }, { left: '$', right: '$', display: false } ] });
  // Web fonts and KaTeX reflow the columns when they arrive; measure after that.
  await document.fonts.ready;
  // Overflowing content is clipped, not moved to a second page, so flag it in red;
  // `make` finds the banner in the PDF and prints a warning. Name the widest offender.
  const m = document.querySelector('main'), b = document.body;
  if (m.scrollWidth > m.clientWidth + 1 || m.scrollHeight > m.clientHeight + 1 || b.scrollWidth > b.clientWidth + 1) {
    const W = b.clientWidth, bad = [...document.querySelectorAll('body *')].find(e => !e.closest('.katex') && e.getBoundingClientRect().right > W + 1);
    const who = bad ? ` (${bad.tagName.toLowerCase()}.${bad.className || ''}: ${(bad.textContent || '').trim().slice(0, 40)})` : '';
    document.body.insertAdjacentHTML('beforeend', '<div id="overflow">OVERFLOW: content does not fit' + who + '</div>');
  }
});
