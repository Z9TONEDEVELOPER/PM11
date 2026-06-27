<?php
/**
 * БИЛЕТ 24 - Задание 3
 * Кодирование Фано и Хаффмана + Продукционный шифр
 * ИСПРАВЛЕННАЯ ВЕРСИЯ (Работает с UTF-8 без mb_* функций)
 */

$message = ". Лев кота на ток вёл";

echo "ИСХОДНОЕ СООБЩЕНИЕ: \"$message\"\n\n";

// =====================================================
// ШАГ 1: ПОДСЧЁТ ЧАСТОТЫ СИМВОЛОВ
// =====================================================

function countFrequencies($text) {
    $freq = [];
    $chars = preg_split('//u', $text, -1, PREG_SPLIT_NO_EMPTY);
    
    foreach ($chars as $char) {
        if (isset($freq[$char])) {
            $freq[$char]++;
        } else {
            $freq[$char] = 1;
        }
    }
    
    arsort($freq);
    return $freq;
}

$frequencies = countFrequencies($message);

echo "ЧАСТОТЫ СИМВОЛОВ:\n";
foreach ($frequencies as $char => $freq) {
    $displayChar = $char === ' ' ? '(пробел)' : $char;
    echo "$displayChar: $freq\n";
}
echo "\n";

// =====================================================
// ШАГ 2: КОДИРОВАНИЕ ШЕННОН-ФАНО
// =====================================================

function shannonFanoEncode($frequencies) {
    $symbols = array_keys($frequencies);
    $codes = [];
    
    $buildCodes = function($syms, $prefix = '') use (&$buildCodes, &$codes, $frequencies) {
        if (count($syms) == 1) {
            $codes[$syms[0]] = $prefix;
            return;
        }
        
        $totalFreq = array_sum(array_map(function($s) use ($frequencies) {
            return $frequencies[$s];
        }, $syms));
        
        $bestSplit = 0;
        $minDiff = $totalFreq;
        $leftSum = 0;
        
        for ($i = 0; $i < count($syms) - 1; $i++) {
            $leftSum += $frequencies[$syms[$i]];
            $rightSum = $totalFreq - $leftSum;
            $diff = abs($leftSum - $rightSum);
            
            if ($diff < $minDiff) {
                $minDiff = $diff;
                $bestSplit = $i + 1;
            }
        }
        
        $left = array_slice($syms, 0, $bestSplit);
        $right = array_slice($syms, $bestSplit);
        
        if (!empty($left)) $buildCodes($left, $prefix . '0');
        if (!empty($right)) $buildCodes($right, $prefix . '1');
    };
    
    $buildCodes($symbols);
    return $codes;
}

$fanoCodes = shannonFanoEncode($frequencies);

echo "КОДЫ ШЕННОН-ФАНО:\n";
foreach ($fanoCodes as $char => $code) {
    $displayChar = $char === ' ' ? '(пробел)' : $char;
    echo "$displayChar: $code\n";
}
echo "\n";

// =====================================================
// ШАГ 3: КОДИРОВАНИЕ ХАФФМАНА
// =====================================================

class HuffmanNode {
    public $char;
    public $freq;
    public $left;
    public $right;
    
    public function __construct($char, $freq) {
        $this->char = $char;
        $this->freq = $freq;
        $this->left = null;
        $this->right = null;
    }
}

function huffmanEncode($frequencies) {
    $nodes = [];
    foreach ($frequencies as $char => $freq) {
        $nodes[] = new HuffmanNode($char, $freq);
    }
    
    while (count($nodes) > 1) {
        usort($nodes, function($a, $b) {
            return $a->freq - $b->freq;
        });
        
        $left = array_shift($nodes);
        $right = array_shift($nodes);
        
        $parent = new HuffmanNode(null, $left->freq + $right->freq);
        $parent->left = $left;
        $parent->right = $right;
        
        $nodes[] = $parent;
    }
    
    $codes = [];
    $generateCodes = function($node, $code = '') use (&$generateCodes, &$codes) {
        if ($node->char !== null) {
            $codes[$node->char] = $code;
            return;
        }
        if ($node->left) $generateCodes($node->left, $code . '0');
        if ($node->right) $generateCodes($node->right, $code . '1');
    };
    
    $generateCodes($nodes[0]);
    return $codes;
}

$huffmanCodes = huffmanEncode($frequencies);

echo "КОДЫ ХАФФМАНА:\n";
foreach ($huffmanCodes as $char => $code) {
    $displayChar = $char === ' ' ? '(пробел)' : $char;
    echo "$displayChar: $code\n";
}
echo "\n";

// =====================================================
// ШАГ 4: ПРОДУКЦИОННЫЙ ШИФР (ИСПРАВЛЕНО: через массивы)
// =====================================================

function productCipher($text) {
    $result = '';
    $chars = preg_split('//u', $text, -1, PREG_SPLIT_NO_EMPTY);
    
    $vowelsStr = 'аеёиоуыэюяАЕЁИОУЫЭЮЯ';
    $alphabetStr = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';
    
    // Разбиваем строки на массивы символов (это решает проблему с UTF-8)
    $vowelsArr = preg_split('//u', $vowelsStr, -1, PREG_SPLIT_NO_EMPTY);
    $alphabetArr = preg_split('//u', $alphabetStr, -1, PREG_SPLIT_NO_EMPTY);
    
    foreach ($chars as $char) {
        if ($char === ' ' || $char === '.') {
            // Пробел и точка остаются без изменений
            $result .= $char;
        } else {
            // Ищем позицию буквы в алфавите
            $pos = array_search($char, $alphabetArr);
            
            if ($pos !== false) {
                // Проверяем, гласная ли буква
                $isVowel = in_array($char, $vowelsArr);
                
                if ($isVowel) {
                    // Гласная -> сдвиг на +1 (берем следующий элемент массива)
                    $result .= $alphabetArr[$pos + 1];
                } else {
                    // Согласная -> сдвиг на -1 (берем предыдущий элемент массива)
                    $result .= $alphabetArr[$pos - 1];
                }
            } else {
                $result .= $char;
            }
        }
    }
    return $result;
}

$encrypted = productCipher($message);
echo "ПРОДУКЦИОННЫЙ ШИФР:\n";
echo "Зашифрованное сообщение: \"$encrypted\"\n\n";

// =====================================================
// ФИНАЛЬНЫЙ ВЫВОД ЗАКОДИРОВАННЫХ СООБЩЕНИЙ
// =====================================================

function encodeMessage($text, $codes) {
    $encoded = '';
    $chars = preg_split('//u', $text, -1, PREG_SPLIT_NO_EMPTY);
    
    foreach ($chars as $char) {
        $encoded .= $codes[$char] . ' ';
    }
    return trim($encoded);
}

echo "ЗАКОДИРОВАННОЕ СООБЩЕНИЕ (ФАНО):\n" . encodeMessage($message, $fanoCodes) . "\n\n";
echo "ЗАКОДИРОВАННОЕ СООБЩЕНИЕ (ХАФФМАН):\n" . encodeMessage($message, $huffmanCodes) . "\n";
?>