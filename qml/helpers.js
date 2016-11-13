.pragma library

function formatDate(dt)
{
    dt = new Date(dt);

    var formattedDate = '%1.%2.%3 | %4:%5'
        .arg(padLeft(dt.getDate(), '0', 2))
        .arg(padLeft(dt.getMonth() + 1, '0', 2))
        .arg(dt.getFullYear())
        .arg(padLeft(dt.getHours(), '0', 2))
        .arg(padLeft(dt.getMinutes(), '0', 2))

    return formattedDate
}

function padLeft(str, ch, width)
{
    var s = String(str);

    while (s.length < width)
        s = ch + s;

    return s;
}
