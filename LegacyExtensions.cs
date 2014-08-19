using System;
using System.Collections.Generic;

namespace OpenXmlPowerTools
{
    public static class LegacyExtensions
    {
        public static IEnumerable<TResult> Zip<TFirst, TSecond, TResult>(this IEnumerable<TFirst> first, IEnumerable<TSecond> second, Func<TFirst, TSecond, TResult> resultSelector)
        {
            using (var ef = first.GetEnumerator())
            using (var es = second.GetEnumerator())
            {
                while (ef.MoveNext() && es.MoveNext())
                {
                    yield return resultSelector(ef.Current, es.Current);
                }
            }
        }
    }
}
