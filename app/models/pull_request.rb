# frozen_string_literal: true

class PullRequest < ActiveRecord::Base
  belongs_to :issue
  validates :url, presence: true

  def state
    if merged_at.present?
      :merged
    elsif %w[CLEAN].include? mergeable_state
      :mergeable
    else
      :opened
    end
  end

  def number
    scan_url if @number.nil?
    @number.to_i
  end

  def repo_owner
    scan_url if @repo_owner.nil?
    @repo_owner
  end

  def repo_name
    scan_url if @repo_name.nil?
    @repo_name
  end

  def repository
    @repository ||= Repository::Github.find_by(url: "https://github.com/#{repo_owner}/#{repo_name}.git")
  end

  def sync
    return unless repository

    ret = RedmineGithub::GithubApi::Graphql.client_by_repository(repository).fetch_pull_request(self)
    return if ret.errors.any? # TODO: logging

    pr = ret.data.repository.pull_request
    update(merged_at: pr.merged_at, mergeable_state: pr.merge_state_status)
  end

  private

  def scan_url
    @repo_owner, @repo_name, @number = url.to_s.scan(%r{\Ahttps://github.com/(.+)/(.+)/pull/(\d+)\z}).flatten
  end
end
