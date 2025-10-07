{
  rootPath,
  melpaSrc,
  elpaSrc,
  nongnuElpaSrc,
}:

[
  {
    name = "custom";
    type = "melpa";
    path = rootPath + "/recipes";
  }
  {
    name = "melpa";
    type = "melpa";
    path = melpaSrc + "/recipes";
  }
  {
    name = "elpa";
    type = "elpa";
    path = elpaSrc + "/elpa-packages";
  }
  {
    name = "nongnu-elpa";
    type = "elpa";
    path = nongnuElpaSrc + "/elpa-packages";
  }
  {
    name = "gnu-archive";
    type = "archive";
    url = "https://elpa.gnu.org/packages/";
  }
  {
    name = "nongnu-archive";
    type = "archive";
    url = "https://elpa.nongnu.org/nongnu/";
  }
]
