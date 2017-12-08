function json2string(strObject) {
    var c, i, l, s = '', v, p;
    switch (typeof strObject) {
        case 'object':
            if (strObject) {
                if (strObject.length && typeof strObject.length == 'number') {
                    for (i = 0; i < strObject.length; ++i) {
                        v = json2string(strObject[i]);
                        if (s) {
                            s += ',';
                        }
                        s += v;
                    }
                    return '[' + s + ']';
                } else if (typeof strObject.toString != 'undefined') {
                    for (i in strObject) {
                        v = strObject[i];
                        if (typeof v != 'undefined' && typeof v != 'function') {
                            v = json2string(v);
                            if (s) {
                                s += ',';
                            }
                            s += json2string(i) + ':' + v;
                        }
                    }
                    return '{' + s + '}';
                }
            }
            return 'null';
        case 'number':
            return isFinite(strObject) ? String(strObject) : 'null';
        case 'string':
            l = strObject.length;
            s = '"';
            for (i = 0; i < l; i += 1) {
                c = strObject.charAt(i);
                if (c >= ' ') {
                    if (c == '\\' || c == '"') {
                        s += '\\';
                    }
                    s += c;
                } else {
                    switch (c) {
                        case '\b':
                            s += '\\b';
                            break;
                        case '\f':
                            s += '\\f';
                            break;
                        case '\n':
                            s += '\\n';
                            break;
                        case '\r':
                            s += '\\r';
                            break;
                        case '\t':
                            s += '\\t';
                            break;
                        default:
                            c = c.charCodeAt();
                            s += '\\u00' + Math.floor(c / 16).toString(16) +
       (c % 16).toString(16);
                    }
                }
            }
            return s + '"';
        case 'boolean':
            return String(strObject);
        default:
            return 'null';
    }
}