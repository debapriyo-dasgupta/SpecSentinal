"""
specsentinel/engine/rule_matcher.py

Bridges the signal extractor and vector DB.
For each signal from an OpenAPI spec, queries the vector store
and returns matched rules with similarity scores.
"""

import logging
from dataclasses import dataclass, field
from typing import Optional

from src.engine.signal_extractor import Signal
from src.vectordb.store.chroma_client import SpecSentinelVectorStore

logger = logging.getLogger(__name__)

# Minimum similarity threshold — below this, matches are ignored
SIMILARITY_THRESHOLD = 0.35


@dataclass
class RuleMatch:
    """A rule matched to a signal, with full context for reporting."""
    signal:      Signal
    rule_id:     str
    title:       str
    severity:    str
    category:    str
    source:      str
    benchmark:   str
    fix_guidance: str
    check_pattern: str
    tags:        list[str]
    similarity:  float
    weight:      int = 15


@dataclass
class FindingGroup:
    """All rule matches for a single signal, de-duped and ranked."""
    signal:       Signal
    matches:      list[RuleMatch] = field(default_factory=list)

    @property
    def top_match(self) -> Optional[RuleMatch]:
        return self.matches[0] if self.matches else None

    @property
    def highest_severity(self) -> str:
        order = {"Critical": 4, "High": 3, "Medium": 2, "Low": 1}
        if not self.matches:
            return "Low"
        return max(self.matches, key=lambda m: order.get(m.severity, 0)).severity


class RuleMatcher:
    """
    Queries the vector DB for rules matching each signal extracted from an API spec.

    Usage:
        matcher = RuleMatcher(store)
        findings = matcher.match_signals(signals)
    """

    def __init__(
        self,
        store: SpecSentinelVectorStore,
        n_results_per_signal: int = 3,
        similarity_threshold: float = SIMILARITY_THRESHOLD,
    ):
        self.store     = store
        self.n_results = n_results_per_signal
        self.threshold = similarity_threshold

    def match_signal(self, signal: Signal) -> FindingGroup:
        """Query vector DB for a single signal and return matched rules."""
        results = self.store.query_rules(
            category=signal.category,
            query_text=signal.description,
            n_results=self.n_results,
        )

        matches = []
        for r in results:
            if r["similarity"] < self.threshold:
                continue
            matches.append(RuleMatch(
                signal=signal,
                rule_id=r["rule_id"],
                title=r["title"] or "",
                severity=r["severity"] or "Medium",
                category=r["category"] or signal.category,
                source=r["source"] or "",
                benchmark=r["benchmark"] or "",
                fix_guidance=r["fix_guidance"] or "",
                check_pattern=r["check_pattern"] or "",
                tags=r["tags"] or [],
                similarity=r["similarity"],
                weight=int(r.get("weight") or 15),
            ))

        return FindingGroup(signal=signal, matches=matches)

    def match_signals(self, signals: list[Signal]) -> list[FindingGroup]:
        """Match all signals and return a list of FindingGroups."""
        findings = []
        for signal in signals:
            group = self.match_signal(signal)
            if group.matches:
                findings.append(group)
                logger.debug(
                    f"Signal {signal.signal_id}: {len(group.matches)} matches, "
                    f"top={group.top_match.rule_id if group.top_match else 'none'} "
                    f"({group.top_match.similarity:.2f} similarity)"
                )
            else:
                logger.debug(f"Signal {signal.signal_id}: no matches above threshold")

        logger.info(
            f"Matched {len(findings)}/{len(signals)} signals to rules "
            f"(threshold={self.threshold})"
        )
        return findings
