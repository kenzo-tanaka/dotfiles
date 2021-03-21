javascript: (function () {
  const title = document.title;
  const url = window.location.href;
  const textArea = document.createElement("textarea");
  textArea.setAttribute("id", "copyTarget");
  textArea.value = `[${title}](${url})`;
  document.body.appendChild(textArea);

  const copyText = document.querySelector("#copyTarget");
  copyText.select();
  document.execCommand("copy");

  textArea.remove();
})();
