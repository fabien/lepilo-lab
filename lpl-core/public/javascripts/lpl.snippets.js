/*  • lpl snippets                                            */
/*    snippets and messages used by lpl's ajax rendering      */

// lpl.app should do lpl.messages = lpl.snippets.messages["en"]; to assign
// "en" (English) as the language to use, for example

lpl.messages = {};

lpl.snippets = {};
  
lpl.snippets.indicator = {
  gray: '<img alt="indicator animation" src="/images/lpl/loading-small-grey.gif"/>',
  dark: '<img alt="indicator animation" src="/images/lpl/loading-small-dark.gif"/>',
  bright: '<img alt="indicator animation" src="/images/lpl/loading-small-bright.gif"/>',
  green: '<img alt="indicator animation" src="/images/lpl/loading-small-green.gif"/>'
};
  
lpl.snippets.processing = {
  gray: '<div class="processing gray">' + lpl.snippets.indicator.gray + '</div>',
  dark: '<div class="processing dark">' + lpl.snippets.indicator.dark + '</div>',
  topics: '<div class="processing topics"><img alt="indicator animation" src="/images/lpl/loading-small-dark.gif"/><div class="msg"></div></div>',
  topics_edit: '<div class="processing topics_edit"><img alt="indicator animation" src="/images/lpl/loading-small-green.gif"/><div class="msg"></div></div>'
};
  
lpl.snippets.messages = {
  en: {
    lepilolovesyou: "lepilo <span class='red-text'>♥</span> you",
    loading: "Loading...",
    success: "<span class='bigger'>Yay!</span>",
    error: "<span class='red-text bigger'>Fail!</span>",
  }
};
