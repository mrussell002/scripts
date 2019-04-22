#int = $i
#int = $j

$x=1

while ($x -le 100)
{

for ($i=1; $i -le 50; $i++)
{
    for ($j=1; $j -le $i; $j++)
    {
        write-host -NoNewline "O"
    }
    write-host -NoNewline `n
}

for ($i=50; $i -ge 1; $i--)
{

    for ($j=1; $j -le $i; $j++)
    {
        write-host -NoNewline "O"
    }
    write-host -NoNewline `n
}

$x++

}
