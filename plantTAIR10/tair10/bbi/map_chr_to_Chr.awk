BEGIN{OFS="\t"}
{
  if($1=="chr1")  $1="Chr1";
  else if($1=="chr2") $1="Chr2";
  else if($1=="chr3") $1="Chr3";
  else if($1=="chr4") $1="Chr4";
  else if($1=="chr5") $1="Chr5";
  else if($1=="chrCp")$1="ChrC";
  else if($1=="chrMt")$1="ChrM";
  print
}
