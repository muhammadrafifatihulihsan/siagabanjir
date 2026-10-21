"""Routing regressions: forks, invalid promotions, retargets and malformed events."""

import unittest

from validate_pr_policy import validate

REPO = 'muhammadrafifatihulihsan/siagabanjir'


def pr_event(base, head, head_repo=REPO):
    return {
        'repository': {'full_name': REPO},
        'pull_request': {
            'base': {'ref': base, 'repo': {'full_name': REPO}},
            'head': {'ref': head, 'repo': {'full_name': head_repo}},
        },
    }


class PRPolicyTests(unittest.TestCase):
    def test_valid_contributions_and_promotion(self):
        for base, head in [('development', 'branch-rafi'), ('development', 'branch-melia'),
                            ('development', 'branch-hasan'), ('main', 'development')]:
            with self.subTest(base=base, head=head):
                self.assertIn('PASS', validate('pull_request', pr_event(base, head), REPO))

    def test_invalid_routes_and_fork_with_allowed_name(self):
        for base, head, repo in [('main', 'branch-rafi', REPO), ('main', 'main', REPO),
                                    ('development', 'feature/test', REPO),
                                    ('develop', 'branch-melia', REPO),
                                    ('development', 'branch-melia', 'outsider/siagabanjir'),
                                    ('main', 'development', 'outsider/siagabanjir')]:
            with self.subTest(base=base, head=head, repo=repo), self.assertRaises(ValueError):
                validate('pull_request', pr_event(base, head, repo), REPO)

    def test_missing_head_repo_and_wrong_base_repo_fail(self):
        for side, value in [('head', None), ('base', {'full_name': 'other/repo'})]:
            event = pr_event('main', 'development')
            event['pull_request'][side]['repo'] = value
            with self.subTest(side=side), self.assertRaises(ValueError):
                validate('pull_request', event, REPO)

    def test_retargeted_pr_is_rechecked(self):
        event = pr_event('development', 'branch-hasan')
        event['action'] = 'edited'
        event['pull_request']['base']['ref'] = 'main'
        with self.assertRaises(ValueError):
            validate('pull_request', event, REPO)

    def test_push_does_not_claim_pr_validation(self):
        for branch in ['main', 'development', 'branch-rafi', 'branch-melia', 'branch-hasan']:
            event = {'repository': {'full_name': REPO}, 'ref': 'refs/heads/' + branch}
            self.assertIn('arah PR tidak diuji', validate('push', event, REPO))
        for ref in ['refs/tags/v0.1.0', 'refs/heads/develop']:
            with self.subTest(ref=ref), self.assertRaises(ValueError):
                validate('push', {'repository': {'full_name': REPO}, 'ref': ref}, REPO)

    def test_missing_metadata_and_unknown_event_fail(self):
        for name, event, repository in [('pull_request', {}, REPO),
                                        ('pull_request_target', pr_event('main', 'development'), REPO),
                                        ('pull_request', pr_event('main', 'development'), '')]:
            with self.subTest(name=name, repository=repository), self.assertRaises(ValueError):
                validate(name, event, repository)


if __name__ == '__main__':
    unittest.main()
