require 'ostruct'

class ChangeScrobblerOptionsToJsonb < ActiveRecord::Migration[6.0]
  def up
    Scrobbler.types.each { |type| type.const_set 'Options', Class.new }

    scrobbler_map = Scrobbler.all.map do |scrobbler|
      [
        scrobbler.id,
        JSON.parse(YAML.load(scrobbler.options).to_json).except('validation_context', 'errors').symbolize_keys
      ]
    end.to_h

    remove_column :scrobblers, :options, :text

    add_column :scrobblers, :options, :jsonb, default: {}
    add_index :scrobblers, :options, using: :gin

    Scrobbler.all.each { |scrobbler| scrobbler.update options: scrobbler_map[scrobbler.id].to_json }
  end

  def down
    scrobbler_map = Scrobbler.all.map { |scrobbler| [scrobbler.id, scrobbler.options] }.to_h

    remove_index :scrobblers, :options, using: :gin
    remove_column :scrobbler, :options, :jsonb, default: {}

    add_column :scrobblers, :options, :text

    Scrobbler.all.each do |scrobbler|
      scrobbler.options = scrobbler_map[scrobbler.id]
      scrobbler.save!
    end
  end
end
