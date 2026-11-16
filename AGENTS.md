# AGENTS.md

学会ポスターを HTML で書き、ヘッドレス Chrome で 1 枚の PDF にするテンプレート。人間向けの説明は `README.md`。

## 構成

| パス | 役割 |
|---|---|
| `posters/<名前>/` | ポスター 1 枚ぶん。`poster_en.html`・`poster_ja.html`（原稿）、`poster.css`（デザイン）、`poster.js`（数式・QR・はみ出し検出）、`fig/` |
| `posters/_template/` | 雛形。直接編集しない。`make new NAME=<名前>` でコピーして使う |
| `posters/iconip2026-lig/` | 使用例（ICONIP 2026）。中身は書き換えない |
| `tools/poster.mk` | ビルドのルール。各ポスターの `Makefile` はこれを include する 1 行だけ |
| `tools/build.sh`, `tools/find-chrome.sh` | HTML → PDF、プレビュー画像、はみ出しの検出、Chrome の検出 |

## コマンド

```bash
make doctor                       # 必要なツールの確認
make new NAME=<名前>              # 新しいポスター
cd posters/<名前> && make          # PDF を作る（make en / make ja / make watch / make check / make clean）
make all                          # 全ポスターを作る（ビルド系を変えたら必ず通す）
```

## スキル

作業の前に該当するスキルを読む。

- `poster-build`（`.claude/skills/poster-build/SKILL.md`）: 組版・ビルド・はみ出しの直し方・入稿前チェック
- `poster-writing`（`.claude/skills/poster-writing/SKILL.md`）: 帯と本文に何を書くか、量の目安、言い過ぎのチェック、レビューの出し方

`.agents/skills` と `.cursor/skills` は `.claude/skills` へのシンボリックリンクで、Codex・Cursor からも同じスキルが見える。スキルを直すときは `.claude/skills/` の方を編集する。

## 守ること

- 編集したら `make` を実行し、プレビュー PNG を実際に見てから完了とする。`(1 page)` と出ただけで完了にしない。
- CSS は既存の規則を書き換える。ファイル末尾に上書きを積み増さない。
- `tools/` を変えたら、リポジトリの一番上で `make all` を通し、`_template` と `iconip2026-lig` の両方が `(1 page)` になることを確かめる。
- 英語版・日本語版の両方があるポスターは、片方だけ直して終わらせない。
- コミット・push は頼まれたときだけ。
